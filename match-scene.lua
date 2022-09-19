matchScene = {}

function matchScene.set()
  gameState.scene = "match"

  love.update = matchScene.update
  love.draw = matchScene.draw
  love.keypressed = matchScene.keypressed

  matchScene.load()
end

function matchScene.load()
end

function matchScene.update(dt)
end

function matchScene.draw()
  love.graphics.scale(2)
  love.graphics.print("match TODO",50,50)
end

function matchScene.keypressed(key)
end
