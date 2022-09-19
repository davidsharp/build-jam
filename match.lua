-- match class, inits, draws and stores state of match

match = {
  speed = 15,
  moveBy = 16
}

dims = {
  tile_size = 16,
  width = 10,
  height = 10
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
end

function match:newPiece()
  self.piece = {x = (dims.width/2) * dims.tile_size, y = 0}
end

function match:placePiece()
  local x = math.floor(self.piece.x/dims.tile_size)
  local y = math.floor(self.piece.y/dims.tile_size)
  match.filled[''..x..'-'..y] = true
end

function match:keypressed(key)
  if key == 'left' then
    self.piece.x = math.max(0,self.piece.x - dims.tile_size)
  elseif key == 'right' then
    self.piece.x = math.min(dims.width*dims.tile_size,self.piece.x + dims.tile_size)
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
      end
    end
  end

  --love.graphics.rectangle('fill',x + match.piece.x,y + match.piece.y,dims.tile_size,dims.tile_size)
  love.graphics.draw(tiles,getTile(tiles,10,1),x + self.piece.x,y + self.piece.y)
end
