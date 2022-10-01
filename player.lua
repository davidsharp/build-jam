player = {}

function player:new(o)
  o = o or {}

  o.position = o.position or {x=0,y=0}
  o.direction = 'down'
  o.moving = false
  o.frozen = false
  o.frame = 0

  o.sprites = {
    standing = {
      up = love.graphics.newImage('assets/1BITCanariPackTopDown/SPRITES/HEROS/spritesheets/HEROS1bit_Adventurer Idle U.png'),
      right = love.graphics.newImage('assets/1BITCanariPackTopDown/SPRITES/HEROS/spritesheets/HEROS1bit_Adventurer Idle R.png'),
      down = love.graphics.newImage('assets/1BITCanariPackTopDown/SPRITES/HEROS/spritesheets/HEROS1bit_Adventurer Idle D.png')
    },
    walking = {
      up = love.graphics.newImage('assets/1BITCanariPackTopDown/SPRITES/HEROS/spritesheets/HEROS1bit_Adventurer Walk U.png'),
      right = love.graphics.newImage('assets/1BITCanariPackTopDown/SPRITES/HEROS/spritesheets/HEROS1bit_Adventurer Walk R.png'),
      down = love.graphics.newImage('assets/1BITCanariPackTopDown/SPRITES/HEROS/spritesheets/HEROS1bit_Adventurer Walk D.png')
    }
  }
  -- left is just right mirrored
  o.sprites.standing.left = o.sprites.standing.right
  o.sprites.walking.left = o.sprites.walking.right
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
  if self.moving then
    local quad = love.graphics.newQuad(
      math.floor(self.frame % 4) * 16, 0, 16, 16,
      self.sprites.walking[self.direction]
    )
    love.graphics.draw(
      self.sprites.walking[self.direction],quad,
      self.position.x+x+(flipX and 16 or 0),self.position.y+y,0,flipX and -1 or 1,1
    )

    -- TODO, flip down/up too after every cycle
  else
    love.graphics.draw(
      self.sprites.standing[self.direction],self.sprites.standingQuads[self.direction],
      self.position.x+x+(flipX and 16 or 0),self.position.y+y,0,flipX and -1 or 1,1
    )
  end

  --[[
    local quad = love.graphics.newQuad(math.floor(self.frame % frameCount) * self.width, 0, self.width, self.height, sprite)
    love.graphics.draw(sprite,quad,self.x-(self.width*self.scale),self.y-(self.height*self.scale) - offset,0,2 * self.scale,2 * self.scale)
  ]]
end

function player:update(dt)
  -- listen for keyboard buttons here? might be janky
  -- if moving, ignore buttons
  if not self.frozen and not self.moving then
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

      -- adds interact button
      if false and (love.keyboard.isDown('space') or
         love.keyboard.isDown('return')) then
          local collision = nil
          local check = {x=0,y=0}
          if self.direction == 'up' then
            check.y = -16
          elseif self.direction == 'down' then
            check.y = 16
          elseif self.direction == 'left' then
            check.x = -16
          elseif self.direction == 'right' then
            check.x = 16
          end
          if colliders then
            -- colliders might be null, so use pairs > ipairs
            for i,collider in pairs(colliders) do
              if collider.position.x == (self.position.x + check.x) and
              collider.position.y == (self.position.y + check.y) then
                collision = collider
              end
            end
          end
          if collision and collision.solid then collision.callback() end
      end

      if moveDir then
        local collision = nil
        local wallCollision = nil
        if colliders then
          -- colliders might be null, so use pairs > ipairs
          for i,collider in pairs(colliders) do
            if collider.position.x == (self.position.x + moveBy.x) and
            collider.position.y == (self.position.y + moveBy.y) then
              collision = collider
            end
          end
        end
        --local x,y = map:convertPixelToTile(self.position.x + moveBy.x,self.position.y + moveBy.y)
        local x = ((self.position.x + moveBy.x)/16)+1
        local y = ((self.position.y + moveBy.y)/16)+1
        local data = map.layers and map.layers[1] and map.layers[1].data
        wallCollision = (data and data[y] and data[y][x] and data[y][x].gid ~= 0) or false
        self.frame = 0
        self.moving = true
        self.direction = moveDir
        if collision and collision.solid then
          -- don't move and activate callback
          -- consider action button instead?
          collision.callback()
          Timer.after(0.2,function() self.moving = false end)
        -- non-solid collision negates solid walls
        elseif wallCollision and not collision then
          Timer.after(0.2,function() self.moving = false end)
        else Timer.tween(0.5,self.position,
          {x=(self.position.x + moveBy.x),y=(self.position.y + moveBy.y)},
          'linear',
          function()
            self.moving = false
            if collision then collision.callback() end
          end
        )
        end
      end
  end


  -- update frame for animation (maybe reset on move)
  self.frame = self.frame + (dt * 5)
end

function player:move(x,y)
end
