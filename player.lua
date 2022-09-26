player = {}

function player:new(o)
  o = o or {}

  o.position = o.position or {x=0,y=0}
  o.direction = 'left'--'down'
  o.moving = false
  o.frame = 0

  o.sprites = {
    standing = {
      up = love.graphics.newImage('assets/1BITCanariPackTopDown/SPRITES/HEROS/spritesheets/HEROS1bit_Adventurer Idle U.png'),
      right = love.graphics.newImage('assets/1BITCanariPackTopDown/SPRITES/HEROS/spritesheets/HEROS1bit_Adventurer Idle R.png'),
      down = love.graphics.newImage('assets/1BITCanariPackTopDown/SPRITES/HEROS/spritesheets/HEROS1bit_Adventurer Idle D.png')
    }
  }
  -- left is just right mirrored
  o.sprites.standing.left = o.sprites.standing.right
  o.sprites.standingQuads = {
    up = love.graphics.newQuad(0, 0, 16, 16, o.sprites.standing.up),
    right = love.graphics.newQuad(0, 0, 16, 16, o.sprites.standing.right),
    down = love.graphics.newQuad(0, 0, 16, 16, o.sprites.standing.down),
    left = love.graphics.newQuad(0, 0, 16, 16, o.sprites.standing.right)
  }

  setmetatable(o, self)
  self.__index = self
  --self.__tostring = function() return 'player{'..o.id..'}' end

  return o
end

function player:draw(x,y)
  -- draw sprite based on direction
  -- if moving, get animation frame
  -- math.floor(o.frame/4) -- something _like_ this

  local flipX = self.direction == 'left'
  love.graphics.draw(
    self.sprites.standing[self.direction],self.sprites.standingQuads[self.direction],
    self.position.x+x+(flipX and 16 or 0),self.position.y+y,0,flipX and -1 or 1,1)

  --[[
    local quad = love.graphics.newQuad(math.floor(self.frame % frameCount) * self.width, 0, self.width, self.height, sprite)
    love.graphics.draw(sprite,quad,self.x-(self.width*self.scale),self.y-(self.height*self.scale) - offset,0,2 * self.scale,2 * self.scale)
  ]]
end

function player:update(dt)
  -- listen for keyboard buttons here? might be janky
  -- if moving, ignore buttons
  if not self.moving then
      -- on move, tween location to 16 in whichever direction
      local moveDir = nil
      local moveBy = {x=0,y=0}
      if love.keyboard.isDown('up') then
        moveDir = 'up'
        moveBy.y = -16
      elseif love.keyboard.isDown('down') then
        moveDir = 'down'
        moveBy.y = 16
      elseif love.keyboard.isDown('left') then
        moveDir = 'left'
        moveBy.x = -16
      elseif love.keyboard.isDown('right') then
        moveDir = 'right'
        moveBy.x = 16
      end

      if moveDir then
        self.moving = true
        self.direction = moveDir
        Timer.tween(0.5,self.position,
          {x=(self.position.x + moveBy.x),y=(self.position.y + moveBy.y)},
          'linear',
          function() self.moving = false end
        )
      end
  end


  -- update frame for animation (maybe reset on move)
  self.frame = self.frame + dt
end

function player:move(x,y)
end
