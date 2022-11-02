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

-- use tiles as an index in a memoised table
invertedTiles = {}
love.graphics.draw = function(tiles, fauxQuad, x, y)
  TODO()

  drawMe = nil
  if inverted then
    if invertedTiles[tiles] == nil then
      invertedTiles[tiles] = playdate.graphics.image:invertedImage()
    end
    drawMe = invertedTiles[tiles]
  else
    drawMe = tiles
  end

  -- actually draw here
end

-- set flag and draw inverted if true?
inverted = false
love.graphics.setColor = function(colourBit)
  if colourBit == 0 then
    inverted = true
  else
    inverted = false
  end
end

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
