player = {}

function player:new(o)
  o = o or {}

  o.x = o.x or 0
  o.y = o.y or 0
  o.direction = 'down'
  o.moving = false
  o.frame = 0

  setmetatable(o, self)
  self.__index = self
  --self.__tostring = function() return 'player{'..o.id..'}' end

  return o
end

function player:draw()
  -- draw sprite based on direction
  -- if moving, get animation frame
  -- math.floor(o.frame/4) -- something _like_ this
end

function player:update(dt)
  -- listen for keyboard buttons here?
  -- if moving, ignore buttons
  -- on move, tween location to 16 in whichever direction

  -- update frame for animation (maybe reset on move)
  o.frame = o.frame + dt
end

function player:move(x,y)
end
