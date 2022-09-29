-- "overworld", originally was gonna be,
--   but basically a description for the non-puzzle portion
--  show current room, intro "cutscene" possibly also lives here

-- TODO, fix bug where going back from game to map crashes

overworldScene = {
  floor = 0,
  floors = 0,
  residents = {}
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

  overworldScene.loadFloor()
end

function overworldScene.loadFloor()
  map = sti(overworldScene.floor > overworldScene.floors and 'maps/rooftop.lua' or 'maps/room.lua')

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
    callback=function() matchScene.set({callback = function(win)
      if win then
        -- need to set location and stuff and not animate in
        print('won match')
        overworldScene.set()
      else
        -- need to set location and stuff and not animate in
        print('lost match')
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
  love.graphics.scale(2)
  map:draw(world_x,world_y,2,2)
  love.graphics.print('Floor '..(overworldScene.floor == 0 and 'G' or overworldScene.floor),16,16)
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

