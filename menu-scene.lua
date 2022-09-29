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
end

function menuScene.update(dt)
  -- tick the pseudo-random number along a bunch
  math.random()

  Timer.update(dt)
  jukebox.update(dt)
end

function menuScene.draw()
  love.graphics.scale(2)
  love.graphics.print("build [working title]",5*16,5*16)
  if menuScene.ready then love.graphics.print("press enter to start",5*16,6*16) end
end

function menuScene.keypressed(key)
  if menuScene.ready and key == 'return' then
    overworldScene.set()
  end
end
