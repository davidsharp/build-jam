dialogue = {}

function dialogue:new(o)
  o = o or {}

  o.text = o.text or {'This is example dialogue!'}
  o.display = ''
  o.index = 1

  setmetatable(o, self)
  self.__index = self
  --self.__tostring = function() return 'dialogue{'..o.id..'}' end

  if o.parse then self:parse(o.parse) end

  Timer.every(.1, function() o:write() end)

  return o
end

-- parse text that has pages/events/etc?
function dialogue:parse(text)
  -- o.text = ...
end

function dialogue:show()

end

function dialogue:hide()

end

function dialogue:next()

end

function dialogue:write()
  self.display = string.sub(self.text[1],1,self.index)
  self.index = self.index + 1
end

-- each .1 seconds write a letter, PoC
local secondCount = 0
function dialogue:update(dt)
  --[[secondCount = secondCount + dt
  if secondCount > .1 and string.len(self.display)<self.index then
    self:write()
    secondCount = secondCount % .1
  end]]
  -- if string.len > index then activate "next behaviour"
end

function dialogue:draw()
  love.graphics.print(self.display,1,1)
end
