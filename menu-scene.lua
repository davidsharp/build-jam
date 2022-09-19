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
end

function menuScene.draw()
  --love.graphics.setCanvas(canvas)
  love.graphics.print("press enter to start",50,50)
  --love.graphics.setCanvas()
  --love.graphics.draw(canvas,0,0,0,2,2)
end

function menuScene.keypressed(key)
  if key == 'return' then
    matchScene.set()
  end
end
