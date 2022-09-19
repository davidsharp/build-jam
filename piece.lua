piece = {}

function piece:new(o)
  o = o or {}

  o.tl = nil
  o.tr = nil
  o.bl = nil
  o.br = nil

  setmetatable(o, self)
  self.__index = self
  --self.__tostring = function() return 'piece{'..o.id..'}' end

  if o.from then
    o.tl = o.from.tl
    o.tr = o.from.tr
    o.bl = o.from.bl
    o.br = o.from.br
  else
    self:randomise()
  end

  return o
end

function piece:randomise()
  local pieces = {'','','',''}

  local offset = math.random(0,3)

  local count = nil
  local x = math.random()
  if x > 0.5 then count = 3
  elseif x < 0.2 then count = 2
  else count = 4 end

  for i, piece in ipairs(pieces) do
    if i <= count then
      local type = nil
      local x = math.random()
      if x > 0.5 then type = 'brick'
      elseif x < 0.2 then type = 'brick'--'bomb'
      -- todo: work on another type? spark?
      else type = 'brick' end
      pieces[i] = type
    else pieces[i] = nil end
  end

  self.tl = pieces[1] == nil and false or pieces[1]
  self.tr = pieces[2] == nil and false or pieces[2]
  self.bl = pieces[3] == nil and false or pieces[3]
  self.br = pieces[4] == nil and false or pieces[4]

  for i = 0, offset do
    self:rotateLeft()
  end
end

-- rotate clockwise
function piece:rotateLeft()
  temp = {tl = self.bl, tr = self.tl, br = self.tr, bl = self.br}
  self.tl = temp.tl or false
  self.tr = temp.tr or false
  self.bl = temp.bl or false
  self.br = temp.br or false
end

function piece:rotateRight()
end
