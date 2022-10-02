require 'match'

matchScene = {}

function matchScene.set(o)
  gameState.scene = "match"

  love.update = matchScene.update
  love.draw = matchScene.draw
  love.keypressed = matchScene.keypressed

  matchScene.callback = o.callback or function() end

  matchScene.load()
end

function matchScene.load()
  gameState.match = match:new({callback =  matchScene.callback})
  jukebox.switchTrack('game')
end

function matchScene.update(dt)
  -- tick the pseudo-random number along a bunch
  math.random()

  Timer.update(dt)

  if not gameState.match then return end
  gameState.match:update(dt)

  jukebox.update(dt)
end

function matchScene.draw()
  if not gameState.match then return end

  if debug then
    drawDebug()
  end

  -- what if yellow and black like construction tape?
  --love.graphics.setColor(1,1,0)

  love.graphics.scale(2)
  gameState.match:draw((4*16),0)

  box(14*16,2*16,8,9)

  love.graphics.print("next",(14*16), (2*16))
  drawPiece(gameState.match.next,(15*16), (4*16))

  love.graphics.print("lines: "..gameState.match.lines,(14*16), (6*16))
  love.graphics.print("target: "..gameState.match.target,(14*16), (7*16))

  love.graphics.print("time: "..math.floor(gameState.match.timeToBeat - gameState.match.timeElapsed),(14*16), (9*16))
end

function matchScene.keypressed(key)
  if key == 'escape' then
    menuScene.set()
  end
  if not gameState.match then return end
  gameState.match:keypressed(key)
end
