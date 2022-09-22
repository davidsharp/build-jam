piece = {}

piecePool = {
  pieces = {},
  bombs = {}
}

function replenishPool()
  piecePool.pieces = {2,2,3,3,3,3,4,4,4,4}
  piecePool.bombs = {false,false,false,false,false,false,false,'bomb','bomb','spark'}
end
function pieceFromPool()
  if #(piecePool.pieces) == 0 then
    replenishPool()
  end
  local count = table.remove(piecePool.pieces,math.random(1,#(piecePool.pieces)))
  local special = table.remove(piecePool.bombs,math.random(1,#(piecePool.bombs)))

  local pieces = {'','','',''}

  local offset = math.random(0,3)

  -- to start, set everything as bricks
  for i, piece in ipairs(pieces) do
    if i <= count then
      pieces[i] = 'brick'
    else pieces[i] = nil end
  end

  -- lack of special is just a 'brick' for now
  if special then
    pieces[math.random(1,count)] = special
  end

  local temp = {}
  temp.tl = pieces[1] == nil and false or pieces[1]
  temp.tr = pieces[2] == nil and false or pieces[2]
  temp.bl = pieces[3] == nil and false or pieces[3]
  temp.br = pieces[4] == nil and false or pieces[4]

  temp = piece:new({from = temp})

  for i = 0, offset do
    temp:rotateLeft()
  end

  return temp
end

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
    --self:randomise()
    o = pieceFromPool()
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

  -- to start, set everything as bricks
  for i, piece in ipairs(pieces) do
    if i <= count then
      pieces[i] = 'brick'
    else pieces[i] = nil end
  end

  -- set <=1 blocks to be a bomb
  -- somewhere about 1/5 pieces has a bomb
  --  TODO could rework this, perhaps between 3 and 6 turns or something
  local roll = math.random()
  local hasBomb = roll < 0.2
  if hasBomb then
    pieces[math.random(1,count)] = 'bomb'
  end
  -- mutually exclusive?
  --  appears about 1/10 times
  local hasSpark = roll >= 0.2 and roll < 0.3
  if hasSpark then
    pieces[math.random(1,count)] = 'spark'
  end

  self.tl = pieces[1] == nil and false or pieces[1]
  self.tr = pieces[2] == nil and false or pieces[2]
  self.bl = pieces[3] == nil and false or pieces[3]
  self.br = pieces[4] == nil and false or pieces[4]

  for i = 0, offset do
    self:rotateLeft()
  end
end

function piece:rotateLeft()
  self:rotateClockwise()
end
function piece:rotateRight()
  self:rotateAntiClockwise()
end

function piece:rotateClockwise()
  temp = {tl = self.bl, tr = self.tl, br = self.tr, bl = self.br}
  self.tl = temp.tl or false
  self.tr = temp.tr or false
  self.bl = temp.bl or false
  self.br = temp.br or false
end

function piece:rotateAntiClockwise()
  temp = {tl = self.tr, tr = self.br, br = self.bl, bl = self.tl}
  self.tl = temp.tl or false
  self.tr = temp.tr or false
  self.bl = temp.bl or false
  self.br = temp.br or false
end
