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
  -- tick the pseudo-random number along a bunch
  math.random()
  if not gameState.match then return end
  gameState.match:update(dt)
end

function matchScene.draw()
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  if not gameState.match then return end

  love.graphics.scale(2)
  --love.graphics.print("match TODO",30,30)
  gameState.match:draw(48,0)

  love.graphics.print("next",48 + (10*16), 48-32)
  drawPiece(gameState.match.next,48 + (11*16), 48)

  love.graphics.print("floors:"..gameState.match.lines,48 + (10*16), 48+32)
end

function matchScene.keypressed(key)
  if not gameState.match then return end
  gameState.match:keypressed(key)
end
