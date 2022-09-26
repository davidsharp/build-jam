item = {}

function item:new(o)
  o = o or {}

  o.position = o.position or {x=0,y=0}
  o.direction = 'down'
  o.moving = false
  o.frame = 0

  o.tile = o.tile --or {sheet = tiles,quad = getTile(tiles,o.tile_x or 0,o.tile_y or 0)}
  o.solid = o.solid or false
  o.callback = o.callback or function() print('collided!') end

  setmetatable(o, self)
  self.__index = self
  --self.__tostring = function() return 'item{'..o.id..'}' end

  return o
end

function item:draw(x,y)
  love.graphics.draw(
    self.tile.sheet,self.tile.quad,
    self.position.x+x,self.position.y+y
  )
end

function item:update(dt)
end
