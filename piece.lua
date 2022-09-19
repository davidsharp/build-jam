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

  self.tl = pieces[1]
  self.tr = pieces[2]
  self.bl = pieces[3]
  self.br = pieces[4]
end

function piece:rotateLeft()
end

function piece:rotateRight()
end
