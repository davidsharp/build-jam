require 'match'

matchScene = {}

function matchScene.set()
  gameState.scene = "match"

  love.update = matchScene.update
  love.draw = matchScene.draw
  love.keypressed = matchScene.keypressed

  matchScene.load()
end

function matchScene.load()
  gameState.match = match:new()
end

function matchScene.update(dt)
  if not gameState.match then return end
end

function matchScene.draw()
  if not gameState.match then return end

  love.graphics.scale(2)
  love.graphics.print("match TODO",30,30)
  gameState.match:draw(50,50)
end

function matchScene.keypressed(key)
  if not gameState.match then return end
  gameState.match:keypressed(key)
end
