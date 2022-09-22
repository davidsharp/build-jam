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

    setmetatable(o, self)
    self.__index = self
    self.__tostring = function() return 'match{'..o.id..'}' end

    self:init()

    return o
end

function match:init()
  match:newPiece()
  match.filled = {}

  dialog = dialogue:new()

  tileMap = {
    brick = {sheet=tiles,quad=getTile(tiles,11,19)},
    bomb = {sheet=k_tiles_trans,quad=getTile(k_tiles,45,9)},
    spark = {sheet=k_tiles_trans,quad=getTile(k_tiles,36,11)},
    null = {sheet=k_tiles_trans,quad=getTile(k_tiles,35,12)}
  }
end

function match:update(dt)
  debugMovement = false

  if dialog then dialog:update(dt) end

  -- only pauses while held (little test)
  if love.keyboard.isDown('p') then
    paused = true
  else
    paused = false
  end


  if paused then return end

  -- double speed on down *shrug*
  if love.keyboard.isDown('down') then
    self.piece.y = self.piece.y + (dt * match.speed * 2)
  elseif not debugMovement then
    self.piece.y = self.piece.y + (dt * match.speed)
  end
  if debugMovement and love.keyboard.isDown('up') then
    self.piece.y = self.piece.y - (dt * match.speed * 2)
  end

  local hasCollided = false
  local i = math.floor(self.piece.x/dims.tile_size)
  local j = math.floor(self.piece.y/dims.tile_size)
  -- tl
  if self.piece.tl and (self.filled[''..(i-1)..'-'..j] or self.piece.y >= ((dims.height+1)* dims.tile_size)) then
    hasCollided = true
  end
  -- tr
  if self.piece.tr and (self.filled[''..i..'-'..j] or self.piece.y >= ((dims.height+1)* dims.tile_size)) then
    hasCollided = true
  end
  -- bl
  if self.piece.bl and (self.filled[''..(i-1)..'-'..j+1] or self.piece.y >= (dims.height * dims.tile_size)) then
    hasCollided = true
  end
  -- br
  if self.piece.br and (self.filled[''..i..'-'..j+1] or self.piece.y >= (dims.height * dims.tile_size)) then
    hasCollided = true
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

    -- TODO: reward removal of two rows?
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
    -- TODO - setup explosions here
    -- for now, remove bomb and spark
    -- eventually swap for explosion tile, then _that_ should clear around, etc

    -- explosion is a table
    for ii,_explosion in ipairs(explosion) do
      local x = _explosion[1]
      local y = _explosion[2]
      match.filled[''..x..'-'..y] = nil
    end
  end

  sfx.land:play()

  -- check for game over
  -- should happen after explosions, in case that saves it?
  -- (currently can't)
  local y = math.floor(self.piece.y/dims.tile_size)
  if y <= 1 then gameOver = true end

  -- TODO: proper game end (freeze then callback?)
  if gameOver then self:init() end
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
      self.filled[''..c..'-'..r+1]  = self.filled[''..c..'-'..r] 
      self.filled[''..c..'-'..r] = nil
    end
  end
  -- TODO, freeze, blink?, then move
  self.lines = self.lines + 1
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

  -- TODO - rotation collision
  if key == 'a' then
    self.piece:rotateLeft()
  elseif key == 'd' then
    self.piece:rotateRight()
  end

  -- debug, refresh
  if key == 'return' then
    self:init()
  end
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
        love.graphics.draw(tileMap[self.filled[''..i..'-'..j]].sheet,tileMap[self.filled[''..i..'-'..j]].quad,x+(i*dims.tile_size),y+(j*dims.tile_size))
      end
    end
  end

  drawPiece(self.piece,x,y)
  if dialog then dialog:draw() end
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
