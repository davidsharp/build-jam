piece = {}

function piece:new(o)
  o = o or {}

  o.tl = nil
  o.tr = nil
  o.bl = nil
  o.br = nil

  setmetatable(o, self)
  self.__index = self
  self.__tostring = function() return 'piece{'..o.id..'}' end

  self:randomise()

  return o
end

function piece:randomise()
  local pieces = {'','','',''}
  -- 3 or 4 pieces

  for i, piece in ipairs(pieces) do
    pieces[i] = 'brick'
  end

  self.tl = nil --pieces[1] == '' and nil or pieces[1]
  self.tr = pieces[2] == '' and false or pieces[2]
  self.bl = pieces[3] == '' and false or pieces[3]
  self.br = pieces[4] == '' and false or pieces[4]
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
