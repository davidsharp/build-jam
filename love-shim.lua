love = {}

love.graphics = {}

love.graphics.newQuad = function(x, y, w, h, tiles)
  -- fauxQuad, just returns dimensions
  return {x,y,w,h}
end

love.graphics.draw = function(tiles, fauxQuad, x, y)
end
