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

function menuScene.load()
  -- temporary
  jukebox.switchTrack('goofy')

  Timer.after(2,function() menuScene.ready = true end)
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

local world_x = 16*(12.5-5)
local world_y = 16*3
function menuScene.draw()
  love.graphics.scale(2)
  map:draw(world_x,world_y,2,2)
  if stairs then stairs:draw(world_x,world_y) end
  drawBuilding(world_x,world_y+(7*16))
  love.graphics.print("build [working title]",8.5*16,5*16)
  if menuScene.ready then love.graphics.print("press enter to start",8.5*16,6*16) end
end

function menuScene.keypressed(key)
  if menuScene.ready and key == 'return' then
    overworldScene.set()
  end
end
