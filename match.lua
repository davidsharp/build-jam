-- match class, inits, draws and stores state of match

match = {
  speed = 15
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
  match.piece = {x = 0, y = 0}
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
    match.piece.y = match.piece.y + (dt * match.speed)
  end
  match.piece.y = match.piece.y + (dt * match.speed)
end

function match:keypressed(key)
  if key == 'left' then
    match.piece.x = math.max(0,match.piece.x - dims.tile_size)
  elseif key == 'right' then
    match.piece.x = math.min(dims.width*dims.tile_size,match.piece.x + dims.tile_size)
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
    end
  end

  --love.graphics.rectangle('fill',x + match.piece.x,y + match.piece.y,dims.tile_size,dims.tile_size)
  love.graphics.draw(tiles,getTile(tiles,10,1),x + match.piece.x,y + match.piece.y)
end
