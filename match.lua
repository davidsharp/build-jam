-- match class, inits, draws and stores state of match

match = {}

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
    return o
end

function match:update(dt)
end

-- x,y offset are where to draw the match board on the screen
function match:draw(x,y)
  x = x or 0
  y = y or 0
  for i=0, dims.width do
    for j=0, dims.height do
      love.graphics.rectangle("line",x+(i*dims.tile_size),y+(j*dims.tile_size),dims.tile_size,dims.tile_size)
    end
  end
end
