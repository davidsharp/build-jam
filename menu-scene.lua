menuScene = {}

function menuScene.set()
  gameState.scene = "menu"

  love.update = menuScene.update
  love.draw = menuScene.draw
  love.keypressed = menuScene.keypressed

  menuScene.load()
end

function menuScene.load()
end

function menuScene.update(dt)
  -- tick the pseudo-random number along a bunch
  math.random()
end

function menuScene.draw()
  love.graphics.scale(2)
  love.graphics.print("press enter to start",50,50)
end

function menuScene.keypressed(key)
  if key == 'return' then
    matchScene.set()
  end
end
