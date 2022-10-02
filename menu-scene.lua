-- this splash screen should have a few options
-- and maybe show progress through the building being built

menuScene = {
  ready = false
}

function menuScene.set()
  gameState.scene = "menu"

  love.update = menuScene.update
  love.draw = menuScene.draw
  love.keypressed = menuScene.keypressed

  menuScene.load()
end

filename = 'build.sav'
function menuScene.load()
  -- temporary
  jukebox.switchTrack('goofy')

  if not menuScene.ready then
    Timer.after(2,function() menuScene.ready = true end)
    local info = love.filesystem.getInfo(filename)
    if info then
      local contents, size = love.filesystem.read(filename)
      local data = split(contents,'|')
      overworldScene.day = tonumber(data[1])
      overworldScene.floors = tonumber(data[2])
    end
  end
  -- reset player position and animate
  overworldScene.usePlayerPosition = false

  map = sti('maps/rooftop.lua')
  stairs = item:new({tile = tileMap['stairsDown'],position = {x=8*16,y=5*16}})
end

function menuScene.update(dt)
  -- tick the pseudo-random number along a bunch
  math.random()

  Timer.update(dt)
  jukebox.update(dt)
end

local world_x = 16*(12.5)
local world_y = 16*3
function menuScene.draw()
  love.graphics.scale(2)
  map:draw(world_x,world_y-(overworldScene.floors*32),2,2)
  if stairs then stairs:draw(world_x,world_y-(overworldScene.floors*32)) end
  drawBuilding(world_x,world_y+(7*16)-(overworldScene.floors*32))
  love.graphics.print("Build 'n' Blocks",3*16,5*16)
  if menuScene.ready then
    love.graphics.print("press enter to start",2*16,6.5*16)
    love.graphics.print("or s for settings",2.5*16,7.5*16)
  end
end

function menuScene.keypressed(key)
  if menuScene.ready and key == 'return' then
    if overworldScene.day > 14 then
      endscoreScene.set()
    else
      overworldScene.set()
    end
  end
  if menuScene.ready and key == 's' then
    settingsScene.set()
    -- test adding floors
    -- overworldScene.floors = overworldScene.floors + 1
  end
end
