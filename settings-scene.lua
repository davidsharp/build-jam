settingsScene = {}

function settingsScene.set()
  gameState.scene = "settings"

  love.update = settingsScene.update
  love.draw = settingsScene.draw
  love.keypressed = settingsScene.keypressed

  settingsScene.load()
end

function settingsScene.load()
  
end

function settingsScene.update(dt)
  Timer.update(dt)
  jukebox.update(dt)
end

function settingsScene.draw()
  love.graphics.scale(2)
  -- settings
  love.graphics.print('SETTINGS',16,16)
  -- arrow
  love.graphics.print('~',2*16,32+(0*16))
  love.graphics.print('Music '..(true and '[on]' or 'off'),3*16,2*16)
  love.graphics.print('SFX '..(true and '[on]' or 'off'),3*16,3*16)

  -- credits
  love.graphics.print('CREDITS',16,5*16)
  love.graphics.print('Designed + developed by David Sharp',3*16,6*16)
  love.graphics.print('In two weeks, for a "build" jam',3*16,7*16)
  love.graphics.print('(using some mighty fine assets packs)',3*16,8*16)
  love.graphics.print('Graphics by Kenney, Johan Vinet and VectorPixelStar',3*16,9*16)
  love.graphics.print('Font is Somepx\'s Matchup Pro',3*16,10*16)
  love.graphics.print('Music by Joshua "JDSherbert" Herbert',3*16,11*16)
  love.graphics.print('SFX are also by Johan Vinet',3*16,12*16)

end

function settingsScene.keypressed(key)
end
