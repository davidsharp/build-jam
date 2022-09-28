-- this splash screen should have a few options
-- and maybe show progress through the building being built

menuScene = {}

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
end

function menuScene.update(dt)
  -- tick the pseudo-random number along a bunch
  math.random()

  Timer.update(dt)
  jukebox.update(dt)
end

function menuScene.draw()
  love.graphics.scale(2)
  love.graphics.print("press enter to start",50,50)
end

function menuScene.keypressed(key)
  if key == 'return' then
    overworldScene.set()
  end
end
