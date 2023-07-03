-- "overworld", originally was gonna be,
--   but basically a description for the non-puzzle portion
--  show current room, intro "cutscene" possibly also lives here

import 'residents'

overworldScene = {
  floor = 0,
  floors = 0,
  day = 1,
  residents = {},
  -- "usePlayerPosition" decides whether we should use this or init movement
  -- could do opposite and set a reset flag
  usePlayerPosition = false,
  playerPosition = {x=0,y=0}
}

function overworldScene.set()
  gameState.scene = "overworld"

  love.update = overworldScene.update
  love.draw = overworldScene.draw
  love.keypressed = overworldScene.keypressed

  overworldScene.load()
end

function overworldScene.load()
  jukebox.switchTrack('goofy')
  if overworldScene.usePlayerPosition then
    -- assume we have a player?
    --player = player or player:new({position = overworldScene.playerPosition})
    player.position = overworldScene.playerPosition
  else
  player = player:new({position = {x=5*16,y=7*16}})
  player.direction = 'up'
  player.frame = 0
  player.moving = true
  Timer.tween(0.5,player.position,
    {x=player.position.x,y=player.position.y - 16},
    'linear',
    function()
      player.moving = false
      end)
  end

  -- going forward use previous state on reload
  overworldScene.usePlayerPosition = true

  overworldScene.loadFloor()
end

function overworldScene.loadFloor()
  map = sti(overworldScene.floor > overworldScene.floors and 'maps/rooftop.lua' or 'maps/room.lua')

  -- TODO, I think I need to make sure everything is loaded before allowing movement?
  -- sometimes collision is just broken if enter has been pressed to early

  -- move player? Probably set in callback
  person = overworldScene.getPerson()
  stairsDown = overworldScene.getStairsDown()
  stairsUp = overworldScene.getStairsUp()
  door = overworldScene.getDoor()
  -- fixes down when spawn on door
  door2 = overworldScene.getDoor()
  if door2 then door2.position.y = door2.position.y + 16 end
  colliders = {
    person,
    stairsDown,
    stairsUp,
    door,
    door2
  }
end

function overworldScene.getPerson()
  local person = overworldScene.floor == 0 and downstairsBloke or residents[((overworldScene.floor+2) % #residents)+1]
  if true then
    return item:new({tile = tileMap[person.sprite],position = {x=6*16,y=2*16},solid = true,
    callback=function()
      player.frozen = true
      if overworldScene.floor > overworldScene.floors then
        overworldScene.playerPosition = player.position
        dialog = dialogue:new({
          text={person.request},
          face=person.sprite..'_face',
          callback=function()
            dialog = nil
            matchScene.set({
              target = 10 + (overworldScene.floors * 2),
              time = 90 + (overworldScene.floors * 2) + ((overworldScene.day - 1) * 2),
              callback = function(win)
              -- move player to always be facing up at person
              player.position.x = 6*16
              player.position.y = 3*16
              player.direction = 'up'
              if win then
                overworldScene.floors = overworldScene.floors + 1
                overworldScene.set()
                dialog = dialogue:new({
                  text={person.success},
                  face=person.sprite..'_face',
                  callback=function()
                    player.frozen = false
                    -- return to menu
                    overworldScene.endDay()
                  end
                })
              else
                overworldScene.set()
                dialog = dialogue:new({
                  text={person.failure},
                  face=person.sprite..'_face',
                  callback=function()
                    player.frozen = false
                    -- return to menu
                   overworldScene.endDay()
                  end
                })
              end
            end})
          end
        })
      else
        dialog = dialogue:new({
          text=person.dialog[1],
          face=person.sprite..'_face',
          callback=function()
          dialog = nil
          -- TODO, probably better to listen for button press,
          -- then check for button down
          Timer.after(0.1,function()
            player.frozen = false
          end)
        end})
      end
    end})
  end
end

function overworldScene.endDay()
  dialog = dialogue:new({
    text = {'Wow, I\'m pooped!','I should wrap up\nfor the day'},
    face = 'player',
    callback = function()
      dialog = nil
      jukebox.fadeOut()
      player.direction = 'down'
      player.frame = 0
      player.moving = true
      Timer.tween(1,player.position,
          {x=player.position.x,y=(player.position.y + 32)},
          'linear',
          function()
            player.direction = 'right'
          end
        )
      Timer.after(1,function()
        Timer.tween(1,player.position,
          {x=(player.position.x + 32),y=player.position.y},
          'linear',
          function()
            player.moving = false
          end
        )
      end)
      Timer.after(2,function()
        --jukebox.start('goofy')
        --jukebox.switchTrack('goofy')
        if overworldScene.day + 1 >= 15 then
          endscoreScene.set()
          overworldScene.day = overworldScene.day + 1
        else
          menuScene.set()
          overworldScene.day = overworldScene.day + 1
          overworldScene.usePlayerPosition = false
          overworldScene.floor = 0
        end
      end)
    end
  })

  -- save progress!
  local success, message = love.filesystem.write(filename, ""..overworldScene.day.."|"..overworldScene.floors)
  --[[if success then 
    print ('file created')
  else 
    print ('file not created: '..message)
  end]]
end

function overworldScene.getStairsUp()
  if overworldScene.floor <= overworldScene.floors then
    return item:new({tile = tileMap['stairsUp'],position = {x=1*16,y=1*16},
    callback=function()
      sfx.stairs:play()
      Timer.after(0.2,function() sfx.stairs:play() end)
      Timer.after(0.4,function() sfx.stairs:play() end)
      overworldScene.floor = overworldScene.floor + 1
      overworldScene.loadFloor()
      player.position.x = 8*16
      player.position.y = 5*16
      player.direction = 'left'
      player.frame = 0
      player.moving = true
      Timer.tween(0.5,player.position,
          {x=player.position.x - 16,y=player.position.y},
          'linear',
          function()
            player.moving = false
          end
        )
    end})
  end
end
function overworldScene.getStairsDown()
  if overworldScene.floor > 0 then
    return item:new({tile = tileMap['stairsDown'],position = {x=8*16,y=5*16},
    callback=function()
      sfx.stairs:play()
      Timer.after(0.3,function() sfx.stairs:play() end)
      Timer.after(0.6,function() sfx.stairs:play() end)
      overworldScene.floor = overworldScene.floor - 1
      overworldScene.loadFloor()
      player.position.x = 1*16
      player.position.y = 1*16
      player.direction = 'down'
      player.frame = 0
      player.moving = true
      Timer.tween(0.5,player.position,
          {x=player.position.x,y=(player.position.y + 16)},
          'linear',
          function()
            player.moving = false
          end
        )
    end})
  end
end
function overworldScene.getDoor()
  if overworldScene.floor == 0 then
    return item:new({tile = tileMap['door'],position = {x=5*16,y=6*16},
    callback=function()
      menuScene.set()
    end})
  end
end


function overworldScene.update(dt)
  Timer.update(dt)
  jukebox.update(dt)
  player:update(dt)
  if dialog then dialog:update(dt) end
end

local world_x = 16*(12.5-5)
local world_y = 16*3
local days = {
  'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'
}
function overworldScene.draw()
  if debug then drawDebug() end
  love.graphics.scale(2)
  map:draw(world_x,world_y,2,2)
  love.graphics.print('Floor '..(overworldScene.floor == 0 and 'G' or overworldScene.floor),16,16)
  love.graphics.print(days[(overworldScene.day%7)+1],16,16*3)
  love.graphics.print(''..(overworldScene.day + 18 <= 30 and overworldScene.day + 18 or overworldScene.day - 12)..(
    ((overworldScene.day + 18) % 10 == 1 and 'st') or
    ((overworldScene.day + 18) % 10 == 2 and 'nd') or
    ((overworldScene.day + 18) % 10 == 3 and 'rd') or
    'th'
  )..(overworldScene.day <= 12 and ' September' or ' October'),16,16*2)
  if person then person:draw(world_x,world_y) end
  if stairsDown then stairsDown:draw(world_x,world_y) end
  if stairsUp then stairsUp:draw(world_x,world_y) end
  if door then door:draw(world_x,world_y) end

  if overworldScene.floor > overworldScene.floors then
    drawBuilding(world_x,world_y+(16*7))
  end

  if dialog then dialog:draw(16*(12.5-5),16*10) end

  player:draw(world_x,world_y)
end

function overworldScene.keypressed(key)
  if debug and key == 'd' then overworldScene.day = overworldScene.day + 1 end
end

