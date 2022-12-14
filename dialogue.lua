dialogue = {}

function dialogue:new(o)
  o = o or {}

  o.text = o.text or {'This is example dialogue!','This is more example dialogue...'}
  o.display = ''
  o.index = 1
  o.boxIndex = 1
  o.callback = o.callback or function() print('no callback on "'..o.text[1]..'"')  end
  o.face = o.face or nil

  pressToContinue = pressToContinue or getTile(k_tiles,25,21)

  setmetatable(o, self)
  self.__index = self
  --self.__tostring = function() return 'dialogue{'..o.id..'}' end

  if o.parse then self:parse(o.parse) end

  Timer.every(.05, function() o:write() end)

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
  if love.keyboard.isDown('space') or love.keyboard.isDown('return') then
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
  local x = (x or 180) + (self.face and 8 or 0)
  local y = (y or 100) + (self.face and 8 or 0)
  box(x,y,10,2,0,frames.speech,true)
  love.graphics.setColor(0,0,0)
  love.graphics.print(self.display,x,y)
  if string.len(self.display) == string.len(self.text[self.boxIndex]) and
  self.text[self.boxIndex+1] then
    -- make this nicer?
    love.graphics.draw(k_tiles_trans,pressToContinue,x+(16*9),y+16+8)
  end
  love.graphics.setColor(1,1,1)

  -- TODO - also draw face, and make box bigger?
  if self.face and tileMap[self.face] then
    love.graphics.draw(tileMap[self.face].sheet,tileMap[self.face].quad,x-16-8,y+8+16)
  end
end
