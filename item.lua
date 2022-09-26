item = {}

function item:new(o)
  o = o or {}

  o.position = o.position or {x=0,y=0}
  o.direction = 'down'
  o.moving = false
  o.frame = 0

  o.sprite = nil
  o.quad = nil
  o.solid = o.solid or false
  o.callback = o.callback or function() end

  setmetatable(o, self)
  self.__index = self
  --self.__tostring = function() return 'item{'..o.id..'}' end

  return o
end

function item:draw(x,y)
end

function item:update(dt)
end
