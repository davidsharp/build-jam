-- "overworld", originally was gonna be,
--   but basically a description for the non-puzzle portion
--  show current room, intro "cutscene" possibly also lives here

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
  -- TODO - add more people
  if true then
    return item:new({tile = tileMap['person'],position = {x=6*16,y=2*16},solid = true,
    callback=function()
      overworldScene.playerPosition = player.position
      matchScene.set({callback = function(win)
      if win then
        print('won match')
        overworldScene.day = overworldScene.day + 1
        overworldScene.set()
      else
        print('lost match')
        overworldScene.day = overworldScene.day + 1
        overworldScene.set()
      end
    end}) end})
  end
end

function overworldScene.getStairsUp()
  if overworldScene.floor <= overworldScene.floors then
    return item:new({tile = tileMap['stairsUp'],position = {x=1*16,y=1*16},
    callback=function()
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
end

local world_x = 16 * 5
local world_y = 16*5
function overworldScene.draw()
  if debug then drawDebug() end
  love.graphics.scale(2)
  map:draw(world_x,world_y,2,2)
  love.graphics.print('Floor '..(overworldScene.floor == 0 and 'G' or overworldScene.floor),16,16)
  love.graphics.print(''..overworldScene.day..(
    (overworldScene.day % 10 == 1 and 'st') or
    (overworldScene.day % 10 == 2 and 'nd') or
    (overworldScene.day % 10 == 3 and 'rd') or
    'th'
  )..' September',16,32)
  if person then person:draw(world_x,world_y) end
  if stairsDown then stairsDown:draw(world_x,world_y) end
  if stairsUp then stairsUp:draw(world_x,world_y) end
  if door then door:draw(world_x,world_y) end

  player:draw(world_x,world_y)
end

function overworldScene.keypressed(key)
  -- testing floor logic
  if key == 'space' then
    overworldScene.floor = overworldScene.floors + 1
    overworldScene.loadFloor()
  end
end

