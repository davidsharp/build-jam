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

    setmetatable(o, self)
    self.__index = self
    self.__tostring = function() return 'match{'..o.id..'}' end

    self:init()

    return o
end

function match:init()
  match:newPiece()
  match.filled = {}
end

function match:update(dt)
  --[[if love.keyboard.isDown('left') then
    match.piece.x = match.piece.x - (dt * 50)
  end
  if love.keyboard.isDown('right') then
    match.piece.x = match.piece.x + (dt * 50)
  end]]
  -- double speed on down *shrug*
  if love.keyboard.isDown('down') then
    self.piece.y = self.piece.y + (dt * match.speed)
  end
  self.piece.y = self.piece.y + (dt * match.speed)

  if (self.piece.y) >= (dims.height * dims.tile_size) then
    self:placePiece(self.piece)
    self:newPiece()
  end

  local hasCollided = false
  -- TODO ignore non-filled pieces
  local i = math.floor(self.piece.x/dims.tile_size)
  local j = math.floor(self.piece.y/dims.tile_size)
  -- tl
  if self.filled[''..(i-1)..'-'..j] then
    hasCollided = true
  end
  -- tr
  if self.filled[''..i..'-'..j] then
    hasCollided = true
  end
  -- bl
  if self.filled[''..(i-1)..'-'..j+1] then
    hasCollided = true
  end
  -- br
  if self.filled[''..i..'-'..j+1] then
    hasCollided = true
  end
  if hasCollided then
    self:placePiece(self.piece)
    self:newPiece()
  end
end

function match:newPiece()
  self.piece = piece:new()
  self.piece.x = (dims.width/2) * dims.tile_size
  self.piece.y = -dims.tile_size
end

function match:placePiece()
  -- Consider refactoring
  if self.piece.tl then
    local x = math.floor(self.piece.x/dims.tile_size)-1
    local y = math.floor(self.piece.y/dims.tile_size)-1
    match.filled[''..x..'-'..y] = true
  end
  if self.piece.tr then
    local x = math.floor(self.piece.x/dims.tile_size)
    local y = math.floor(self.piece.y/dims.tile_size)-1
    match.filled[''..x..'-'..y] = true
  end
  if self.piece.bl then
    local x = math.floor(self.piece.x/dims.tile_size)-1
    local y = math.floor(self.piece.y/dims.tile_size)
    match.filled[''..x..'-'..y] = true
  end
  if self.piece.br then
    local x = math.floor(self.piece.x/dims.tile_size)
    local y = math.floor(self.piece.y/dims.tile_size)
    match.filled[''..x..'-'..y] = true
  end
end

function match:rotatePiece()
  --
end

function match:keypressed(key)
  local x = math.floor(self.piece.x/dims.tile_size)
  local y = math.floor(self.piece.y/dims.tile_size)
  local hasCollided = false
  if key == 'left' then
    print(x,y)
    -- TODO ignore non-filled pieces
    -- tl
    if self.filled[''..(x-2)..'-'..y] then
      hasCollided = true
    end
    -- bl
    if self.filled[''..(x-2)..'-'..y+1] then
      hasCollided = true
    end
    if not hasCollided then
      -- 1 is minimum, as piece center is always one square in
      self.piece.x = math.max(dims.tile_size,self.piece.x - match.moveBy)
    end
  elseif key == 'right' then
    -- TODO ignore non-filled pieces
    -- tr
    if self.filled[''..(x+1)..'-'..y] then
      hasCollided = true
    end
    -- br
    if self.filled[''..(x+1)..'-'..y+1] then
      hasCollided = true
    end
    if not hasCollided then
      self.piece.x = math.min(dims.width*dims.tile_size,self.piece.x + match.moveBy)
    end
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
  for i=0, dims.width do
    for j=0, dims.height do
      love.graphics.rectangle("line",x+(i*dims.tile_size),y+(j*dims.tile_size),dims.tile_size,dims.tile_size)
      if self.filled[''..i..'-'..j] then
        love.graphics.rectangle("fill",x+(i*dims.tile_size),y+(j*dims.tile_size),dims.tile_size,dims.tile_size)
        --love.graphics.print(''..i..'-'..j,x+(i*dims.tile_size),y+(j*dims.tile_size))
      end
    end
  end

  --love.graphics.rectangle('fill',x + match.piece.x,y + match.piece.y,dims.tile_size,dims.tile_size)
  if self.piece.br ~= nil then
    love.graphics.draw(tiles,getTile(tiles,10,1),x + self.piece.x,y + self.piece.y)
  end
  if self.piece.bl then
    love.graphics.draw(tiles,getTile(tiles,10,1),x + self.piece.x - dims.tile_size,y + self.piece.y)
  end
  if self.piece.tr then
    love.graphics.draw(tiles,getTile(tiles,10,1),x + self.piece.x,y + self.piece.y - dims.tile_size)
  end
  if self.piece.tl then
    love.graphics.draw(tiles,getTile(tiles,10,1),x + self.piece.x - dims.tile_size,y + self.piece.y - dims.tile_size)
  end
end
