-- import _before_ main

love = {}

local TOOD = function()
  print('TODO')
end

love.graphics = {}

love.graphics.newImage = TODO

love.graphics.newQuad = function(x, y, w, h, tiles)
  -- fauxQuad, just returns dimensions
  return {x,y,w,h}
end

love.graphics.draw = function(tiles, fauxQuad, x, y)
  TODO()
end

love.graphics.setColor = TODO

love.graphics.rectangle = TODO

love.graphics.print = TODO

-- no-op, Used for Love2D only
love.graphics.scale = function() end

love.audio = {}

love.audio.newSource = TODO

love.keyboard = {}

love.keyboard.isPressed = TODO

love.filesystem = {}

love.filesystem.getInfo = TODO

love.filesystem.read = TODO

love.filesystem.remove = TODO

love.event = {}

-- no-op, don't need to quit out from game
love.event.quit = function() end

-- STI uses these
love.data = {}
love.math = {}
love.physics = {}
