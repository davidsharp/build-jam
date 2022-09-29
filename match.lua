-- match class, inits, draws and stores state of match

require 'piece'

require 'dialogue'

match = {
  speed = 45,
  moveBy = 16
}

dims = {
  tile_size = 16,
  width = 8,
  height = 14
}

function match:new(o)
    o = o or {}

    --o.score = 0
    o.lines = 0
    o.target = o.target or 10

    o.timeElapsed = 0
    o.timeToBeat = 120

    o.callback = o.callback or function() end

    setmetatable(o, self)
    self.__index = self
    self.__tostring = function() return 'match{'..o.id..'}' end

    self:init()

    return o
end

function match:init()
  match:newPiece()
  match.filled = {}

  --dialog = dialogue:new()

end

function match:update(dt)
  debugMovement = false

  if dialog then dialog:update(dt) end

  -- tween the volume for fade?
  --if paused or frozen then music.game:pause() else music.game:play() end

  if paused or frozen then return end

  self.timeElapsed = self.timeElapsed + dt

  self.piece.canRotate = true

  -- double speed on down *shrug*
  if love.keyboard.isDown('down') then
    self.piece.y = self.piece.y + (dt * match.speed * 2)
  elseif not debugMovement then
    self.piece.y = self.piece.y + (dt * match.speed)
  end
  if debugMovement and love.keyboard.isDown('up') then
    self.piece.y = self.piece.y - (dt * match.speed * 2)
  end

  local hasCollided = false -- only disable when colliding (could be one and done)
  local i = math.floor(self.piece.x/dims.tile_size)
  local j = math.floor(self.piece.y/dims.tile_size)
  -- tl
  if self.piece.tl and (self.filled[''..(i-1)..'-'..j] or self.piece.y >= ((dims.height+1)* dims.tile_size)) then
    hasCollided = true
  elseif (self.filled[''..(i-1)..'-'..j] or self.piece.y >= ((dims.height+1)* dims.tile_size)) then
    self.piece.canRotate = false
  end
  -- tr
  if self.piece.tr and (self.filled[''..i..'-'..j] or self.piece.y >= ((dims.height+1)* dims.tile_size)) then
    hasCollided = true
  elseif (self.filled[''..i..'-'..j] or self.piece.y >= ((dims.height+1)* dims.tile_size)) then
    self.piece.canRotate = false
  end
  -- bl
  if self.piece.bl and (self.filled[''..(i-1)..'-'..j+1] or self.piece.y >= (dims.height * dims.tile_size)) then
    hasCollided = true
  elseif (self.filled[''..(i-1)..'-'..j+1] or self.piece.y >= (dims.height * dims.tile_size)) then
    self.piece.canRotate = false
  end
  -- br
  if self.piece.br and (self.filled[''..i..'-'..j+1] or self.piece.y >= (dims.height * dims.tile_size)) then
    hasCollided = true
  elseif (self.filled[''..i..'-'..j+1] or self.piece.y >= (dims.height * dims.tile_size)) then
    self.piece.canRotate = false
  end
  if hasCollided then
    -- grab rows
    local row = math.floor(self.piece.y/dims.tile_size)

    -- place piece and get new
    self:placePiece(self.piece)
    self:newPiece()

    -- check rows
    self:checkLine(row-1)
    self:checkLine(row)

    local explosions = match:findExplosions()
    if #explosions > 0 then match:explodeExplosions() end

    -- TODO: reward removal of two rows?
  end

  -- TODO: more fanfare, etc
  if self.lines >= self.target then
    self.callback(true)
  end
  if self.timeElapsed >= self.timeToBeat then
    self.callback(false)
  end
end

function match:newPiece()
  self.piece = piece:new({from = self.next}) or piece:new()
  self.next = piece:new()
  self.piece.x = (dims.width/2) * dims.tile_size
  self.piece.y = 0---dims.tile_size
end

function match:checkForExplosion(piece,x,y)
  local type = piece
  local checkingFor = type == 'bomb' and 'spark' or 'bomb'

  local volatileNeighbours = {}
  -- up
  if y > 0 and self.filled[''..x..'-'..(y-1)] == checkingFor then
    table.insert(volatileNeighbours,{x,y-1})
    --self.filled[x,y-1] = nil
  end
  -- down
  if y < dims.height and self.filled[''..x..'-'..(y+1)] == checkingFor then
    table.insert(volatileNeighbours,{x,y+1})
    --self.filled[x,y+1] = nil
  end
  -- left
  if x > 0 and self.filled[''..(x-1)..'-'..y] == checkingFor then
    table.insert(volatileNeighbours,{x-1,y})
    --self.filled[x-1,y] = nil
  end
  -- right
  if x < dims.width and self.filled[''..(x+1)..'-'..y] == checkingFor then
    table.insert(volatileNeighbours,{x+1,y})
    --self.filled[x+1,y] = nil
  end

  -- if there are any volatileNeighbours, then 
  if #volatileNeighbours > 0 then
    table.insert(volatileNeighbours,{x,y})
  end

  return (#volatileNeighbours > 0), volatileNeighbours

  -- Should bombs cause a chain reaction?
  -- should exploded blocks cause blocks to drop?
end

function match:placePiece()
  local gameOver = false
  local exploded = {}
  -- Consider refactoring
  if self.piece.tl then
    local x = math.floor(self.piece.x/dims.tile_size)-1
    local y = math.floor(self.piece.y/dims.tile_size)-1
    match.filled[''..x..'-'..y] = self.piece.tl
    if self.piece.tl == 'bomb' or self.piece.tl == 'spark' then
      local detectedExplosion, explosions = match:checkForExplosion(self.piece.tl,x,y)
      if detectedExplosion then
        table.insert(exploded,explosions)
      end
    end
  end
  if self.piece.tr then
    local x = math.floor(self.piece.x/dims.tile_size)
    local y = math.floor(self.piece.y/dims.tile_size)-1
    match.filled[''..x..'-'..y] = self.piece.tr
    if self.piece.tr == 'bomb' or self.piece.tr == 'spark' then
      local detectedExplosion, explosions = match:checkForExplosion(self.piece.tr,x,y)
      if detectedExplosion then
        table.insert(exploded,explosions)
      end
    end
  end
  if self.piece.bl then
    local x = math.floor(self.piece.x/dims.tile_size)-1
    local y = math.floor(self.piece.y/dims.tile_size)
    match.filled[''..x..'-'..y] = self.piece.bl

    if self.piece.bl == 'bomb' or self.piece.bl == 'spark' then
      local detectedExplosion, explosions = match:checkForExplosion(self.piece.bl,x,y)
      if detectedExplosion then
        table.insert(exploded,explosions)
      end
    end
  end
  if self.piece.br then
    local x = math.floor(self.piece.x/dims.tile_size)
    local y = math.floor(self.piece.y/dims.tile_size)
    match.filled[''..x..'-'..y] = self.piece.br

    if self.piece.br == 'bomb' or self.piece.br == 'spark' then
      local detectedExplosion, explosions = match:checkForExplosion(self.piece.br,x,y)
      if detectedExplosion then
        table.insert(exploded,explosions)
      end
    end
  end

  for i,explosion in ipairs(exploded) do
    -- removes bomb and spark
    -- eventually swap for explosion tile, then _that_ should clear around, etc
    -- TODO - refactor this loop away

    -- explosion is a table
    for ii,_explosion in ipairs(explosion) do
      local x = _explosion[1]
      local y = _explosion[2]
      match.filled[''..x..'-'..y] = 'explosion'
    end
  end
  if #exploded > 0 then
    self:explodeExplosions()
  end

  -- give bombs gravity?
  -- maybe bombs shouldn't clear?

  sfx.land:play()

  -- check for game over
  -- should happen after explosions, in case that saves it?
  -- (currently can't)
  local y = math.floor(self.piece.y/dims.tile_size)
  if y <= 1 then gameOver = true end

  -- TODO: proper game end (freeze then callback?)
  if gameOver then
    --self:init()
    self.callback(false)
  end
end

chaosMode = false
function match:explodeExplosions()
  -- Now freeze the game
  frozen = true
  local explosions = self:findExplosions()
  sfx.explode:play()
  local dust = {}
  local chainReaction = false
  -- Blow up outer (remove squares, set co-ords to be animated)
  for i,exp in ipairs(explosions) do
    local x = exp.x
    local y = exp.y
    -- up
    if y > 0 and self.filled[''..x..'-'..(y-1)] then
      if chaosMode then
        self.filled[''..x..'-'..(y-1)] = 'explosion'
      end
      table.insert(dust,{x=x,y=y-1})
    end
    -- down
    if y < dims.height and self.filled[''..x..'-'..(y+1)] then
      if chaosMode then
        self.filled[''..x..'-'..(y+1)] = 'explosion'
      end
      table.insert(dust,{x=x,y=y+1})
    end
    -- left
    if x > 0 and self.filled[''..(x-1)..'-'..y] then
      if chaosMode then
        self.filled[''..(x-1)..'-'..y] = 'explosion'
      end
      table.insert(dust,{x=x-1,y=y})
    end
    -- right
    if x < dims.width and self.filled[''..(x+1)..'-'..y] then
      if chaosMode then
        self.filled[''..(x+1)..'-'..y] = 'explosion'
      end
      table.insert(dust,{x=x+1,y=y})
    end
  end

  -- bit of a hack, swap out the dust tile, rather than
  -- looping over the explosions a bunch
  tileMap.dust = tileMap.dust1
  Timer.after(0.1, function()
    sfx.explode:play()
    for i,exp in ipairs(explosions) do
      self.filled[''..exp.x..'-'..exp.y] = 'dust'
    end
    for i,exp in ipairs(dust) do
      self.filled[''..exp.x..'-'..exp.y] = 'dust'
    end
  end)

  -- TODO, could be an interval and counter?
  Timer.after(0.2, function() tileMap.dust = tileMap.dust2 end)
  Timer.after(0.3, function() tileMap.dust = tileMap.dust3 end)
  Timer.after(0.4, function() tileMap.dust = tileMap.dust4 end)

  Timer.after(0.5, function()
    sfx.explode:play()
    for i,exp in ipairs(explosions) do
      self.filled[''..exp.x..'-'..exp.y] = nil
    end
    for i,exp in ipairs(dust) do
      self.filled[''..exp.x..'-'..exp.y] = nil
    end
  end)

  -- TODO ~ Handle chain?
  -- "fix" to animation seems to do a crude chain reaction :o
  -- it maybe still looks a bit weird though

  -- done
  Timer.after(0.5, function() frozen = false end)
end

function match:findExplosions()
  local explosions = {}
  for key,value in pairs(self.filled) do
    if value == 'explosion' then
      local coords = split(key,'-')
      table.insert(explosions,{x = tonumber(coords[1]),y = tonumber(coords[2])})
    end
  end
  return explosions
end

-- accept an arbitrary number of rows?
function match:checkLine(row)
  local foundEmpty = false
  for i=0,dims.width do
    if not self.filled[''..i..'-'..row] then
      foundEmpty = true
    end
  end
  if not foundEmpty then self:clearLine(row) end
end

function match:clearLine(row)
  -- clear line
  for i=0,dims.width do
    self.filled[''..i..'-'..row] = nil
  end
  -- move blocks above line down
  for r = row-1,0,-1 do
    for c = 0,dims.width do
      -- check for explosions!
      if (self.filled[''..c..'-'..r] == 'bomb' or self.filled[''..c..'-'..r] == 'spark')
        and self.filled[''..c..'-'..r+2] == (self.filled[''..c..'-'..r] == 'bomb' and 'spark' or 'bomb') then
        self.filled[''..c..'-'..r+1] = 'explosion'
        self.filled[''..c..'-'..r+2] = 'explosion'
      else
        self.filled[''..c..'-'..r+1]  = self.filled[''..c..'-'..r]
      end
      self.filled[''..c..'-'..r] = nil
    end
  end
  -- TODO, freeze, blink?, then move
  self.lines = self.lines + 1

  sfx.clear:play()
end

function match:rotatePiece()
  --
end

function match:keypressed(key)
  local x = math.floor(self.piece.x/dims.tile_size)
  local y = math.floor(self.piece.y/dims.tile_size)
  local hasCollided = false
  if key == 'left' then
    -- TODO ignore non-filled pieces
    -- tl
    if self.piece.tl and self.filled[''..(x-2)..'-'..y] then
      hasCollided = true
    end
    -- bl
    if self.piece.bl and self.filled[''..(x-2)..'-'..y+1] then
      hasCollided = true
    end
    if not hasCollided then
      -- 1 is minimum, as piece center is always one square in
      self.piece.x = math.max(dims.tile_size,self.piece.x - match.moveBy)
    end
  elseif key == 'right' then
    -- TODO ignore non-filled pieces
    -- tr
    if self.piece.tr and self.filled[''..(x+1)..'-'..y] then
      hasCollided = true
    end
    -- br
    if self.piece.br and self.filled[''..(x+1)..'-'..y+1] then
      hasCollided = true
    end
    if not hasCollided then
      self.piece.x = math.min(dims.width*dims.tile_size,self.piece.x + match.moveBy)
    end
  end

  -- only rotate if there's room for it
  if self.piece.canRotate and key == 'a' then
    self.piece:rotateLeft()
  elseif self.piece.canRotate and key == 'd' then
    self.piece:rotateRight()
  end

  if key == 'p' then
    paused = not paused
  end

  -- debug, refresh
  --[[if key == 'return' then
    self:init()
  end]]
end

-- x,y offset are where to draw the match board on the screen
-- could be a canvas?
function match:draw(x,y)
  x = x or 0
  y = y or 0
  love.graphics.rectangle("line",x,y,dims.tile_size*(dims.width+1),dims.tile_size*(dims.height+1))
  -- top-line
  love.graphics.rectangle("line",x,y+dims.tile_size,dims.tile_size*(dims.width+1),1)
  for i=0, dims.width do
    for j=0, dims.height do
      if self.filled[''..i..'-'..j] then
        -- TODO: alternate square if not canRotate?
        love.graphics.draw(
          tileMap[self.filled[''..i..'-'..j]].sheet,
          tileMap[self.filled[''..i..'-'..j]].quad,
          x+(i*dims.tile_size),
          y+(j*dims.tile_size))
      end
    end
  end

  --love.graphics.rectangle("line",x + self.piece.x-18,y + self.piece.y-18,36,36)
  --love.graphics.rectangle("fill",x + self.piece.x-2,y + self.piece.y-2,4,4)
  drawPiece(self.piece,x,y)
  drawCurrentBorder(self.piece,x,y)

  if dialog then dialog:draw() end
end

function drawCurrentBorder(piece,x,y)
  pieceBorderQuads = pieceBorderQuads or {
    love.graphics.newQuad(35 * 16, 12 * 16, 8, 8, k_tiles_trans),
    love.graphics.newQuad(35.5 * 16, 12.5 * 16, 8, 8, k_tiles_trans),
    love.graphics.newQuad(35.5 * 16, 12 * 16, 8, 8, k_tiles_trans),
    love.graphics.newQuad(35 * 16, 12.5 * 16, 8, 8, k_tiles_trans),
  }
  love.graphics.draw(k_tiles_trans, pieceBorderQuads[1], x + piece.x - 20, y + piece.y - 20)
  love.graphics.draw(k_tiles_trans, pieceBorderQuads[2], x + piece.x + 12, y + piece.y + 12)
  love.graphics.draw(k_tiles_trans, pieceBorderQuads[3], x + piece.x + 12, y + piece.y - 20)
  love.graphics.draw(k_tiles_trans, pieceBorderQuads[4], x + piece.x - 20, y + piece.y + 12)
end

function drawPiece(p,x,y)
  -- un-init'd pieces need dimensions setting
  -- TODO, do in :new()
  p.x = p.x or 0
  p.y = p.y or 0

  if p.br then
    love.graphics.draw(tileMap[p.br].sheet,tileMap[p.br].quad,x + p.x,y + p.y)
  else
    love.graphics.draw(tileMap.null.sheet,tileMap.null.quad,x + p.x,y + p.y)
  end
  if p.bl then
    love.graphics.draw(tileMap[p.bl].sheet,tileMap[p.bl].quad,x + p.x - dims.tile_size,y + p.y)
  else
    love.graphics.draw(tileMap.null.sheet,tileMap.null.quad,x + p.x - dims.tile_size,y + p.y)
  end
  if p.tr then
    love.graphics.draw(tileMap[p.tr].sheet,tileMap[p.tr].quad,x + p.x,y + p.y - dims.tile_size)
  else
    love.graphics.draw(tileMap.null.sheet,tileMap.null.quad,x + p.x,y + p.y - dims.tile_size)
  end
  if p.tl then
    love.graphics.draw(tileMap[p.tl].sheet,tileMap[p.tl].quad,x + p.x - dims.tile_size,y + p.y - dims.tile_size)
  else
    love.graphics.draw(tileMap.null.sheet,tileMap.null.quad,x + p.x - dims.tile_size,y + p.y - dims.tile_size)
  end
end
