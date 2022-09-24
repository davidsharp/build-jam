dialogue = {}

function dialogue:new(o)
  o = o or {}

  o.text = o.text or {'This is example dialogue!','This is more example dialogue...'}
  o.display = ''
  o.index = 1
  o.boxIndex = 1
  o.callback = o.callback or function() print('no callback on "'..o.text[1]..'"')  end
  o.face = nil

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
  self.display = string.sub(self.text[self.boxIndex],1,self.index)
  self.index = self.index + 1
end

-- each .1 seconds write a letter, PoC
local secondCount = 0
function dialogue:update(dt)
  if love.keyboard.isDown('space') then
    -- if text is completed
    if string.len(self.display) == string.len(self.text[self.boxIndex]) then
      -- if there's another text box
      if self.text[self.boxIndex+1] then
        self.boxIndex = self.boxIndex + 1
        self.display = ''
        self.index = 1
      -- otherwise fire callback
      else
        if self.callback then
          self.callback()
          -- only run callback once
          self.callback = nil

          self:hide() -- maybe callback should be run on hide
        end
      end
    end
  end
end

-- should be a certain height near the bottom
function dialogue:draw(x,y)
  local x = x or 180
  local y = y or 100
  box(x,y,10,2)
  love.graphics.print(self.display,x,y)
  if string.len(self.display) == string.len(self.text[self.boxIndex]) then
    love.graphics.print('[press space to continue]',x,y+16)
  end
end
