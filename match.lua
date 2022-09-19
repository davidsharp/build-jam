-- match class, inits, draws and stores state of match

require 'piece'

match = {
  speed = 15,
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

  tileMap = {
    brick = getTile(tiles,11,19),
    null = getTile(k_tiles,35,12)
  }
end

function match:update(dt)
  -- double speed on down *shrug*
  if love.keyboard.isDown('down') then
    self.piece.y = self.piece.y + (dt * match.speed)
  end
  self.piece.y = self.piece.y + (dt * match.speed)

  if (
    self.piece.y >= (dims.height * dims.tile_size)
    and
    (self.piece.bl or self.piece.br )
  ) or (
    -- handle only having tl and tr
    self.piece.y >= ((dims.height+1)* dims.tile_size)
  ) then
    self:placePiece(self.piece)
    self:newPiece()
  end

  local hasCollided = false
  local i = math.floor(self.piece.x/dims.tile_size)
  local j = math.floor(self.piece.y/dims.tile_size)
  -- tl
  if self.piece.tl and self.filled[''..(i-1)..'-'..j] then
    hasCollided = true
  end
  -- tr
  if self.piece.tr and self.filled[''..i..'-'..j] then
    hasCollided = true
  end
  -- bl
  if self.piece.bl and self.filled[''..(i-1)..'-'..j+1] then
    hasCollided = true
  end
  -- br
  if self.piece.br and self.filled[''..i..'-'..j+1] then
    hasCollided = true
  end
  if hasCollided then
    self:placePiece(self.piece)
    self:newPiece()
  end
end

function match:newPiece()
  self.piece = piece:new({from = self.next}) or piece:new()
  self.next = piece:new()
  self.piece.x = (dims.width/2) * dims.tile_size
  self.piece.y = 0---dims.tile_size
end

function match:placePiece()
  local gameOver = false
  -- Consider refactoring
  if self.piece.tl then
    local x = math.floor(self.piece.x/dims.tile_size)-1
    local y = math.floor(self.piece.y/dims.tile_size)-1
    match.filled[''..x..'-'..y] = self.piece.tl
  end
  if self.piece.tr then
    local x = math.floor(self.piece.x/dims.tile_size)
    local y = math.floor(self.piece.y/dims.tile_size)-1
    match.filled[''..x..'-'..y] = self.piece.tr
  end
  if self.piece.bl then
    local x = math.floor(self.piece.x/dims.tile_size)-1
    local y = math.floor(self.piece.y/dims.tile_size)
    match.filled[''..x..'-'..y] = self.piece.bl

    if y <= 1 then gameOver = true end
  end
  if self.piece.br then
    local x = math.floor(self.piece.x/dims.tile_size)
    local y = math.floor(self.piece.y/dims.tile_size)
    match.filled[''..x..'-'..y] = self.piece.br

    if y <= 1 then gameOver = true end
  end

  -- TODO: proper game end (freeze then callback?)
  if gameOver then self:init() end
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
        love.graphics.draw(tiles,tileMap[self.filled[''..i..'-'..j]],x+(i*dims.tile_size),y+(j*dims.tile_size))
      end
    end
  end

  drawPiece(self.piece,x,y)
end

function drawPiece(p,x,y)
  -- un-init'd pieces need dimensions setting
  -- TODO, do in :new()
  p.x = p.x or 0
  p.y = p.y or 0

  if p.br then
    love.graphics.draw(tiles,tileMap[p.br],x + p.x,y + p.y)
  else
    love.graphics.draw(k_tiles,tileMap.null,x + p.x,y + p.y)
  end
  if p.bl then
    love.graphics.draw(tiles,tileMap[p.bl],x + p.x - dims.tile_size,y + p.y)
  else
    love.graphics.draw(k_tiles,tileMap.null,x + p.x - dims.tile_size,y + p.y)
  end
  if p.tr then
    love.graphics.draw(tiles,tileMap[p.tr],x + p.x,y + p.y - dims.tile_size)
  else
    love.graphics.draw(k_tiles,tileMap.null,x + p.x,y + p.y - dims.tile_size)
  end
  if p.tl then
    love.graphics.draw(tiles,tileMap[p.tl],x + p.x - dims.tile_size,y + p.y - dims.tile_size)
  else
    love.graphics.draw(k_tiles,tileMap.null,x + p.x - dims.tile_size,y + p.y - dims.tile_size)
  end
end
