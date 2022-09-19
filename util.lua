--memoise?
function getTile(tiles,x,y)
  local quad = love.graphics.newQuad(x * 16, y * 16, 16, 16, tiles)
  return quad
end
