-- util for drawing a box with a sprite border, with an _internal_ x/y/height/width
-- width and height are specified in 16x16 squares, rather than by pixel!
--  perhaps x/y should be too

function box(_x,_y,w,h)
  local x = _x - 8
  local y = _y - 8
  local width = (w * 16) + 16
  local height = (h * 16) + 16
  boxBorderQuads = boxBorderQuads or {
    love.graphics.newQuad(35 * 16, 12 * 16, 8, 8, k_tiles_trans),
    love.graphics.newQuad(35.5 * 16, 12.5 * 16, 8, 8, k_tiles_trans),
    love.graphics.newQuad(35.5 * 16, 12 * 16, 8, 8, k_tiles_trans),
    love.graphics.newQuad(35 * 16, 12.5 * 16, 8, 8, k_tiles_trans),
  }
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('fill',x,y,width+16,height+16)
  love.graphics.setColor(1,1,1)
  love.graphics.draw(k_tiles_trans, pieceBorderQuads[1], x - 4, y - 4)
  love.graphics.draw(k_tiles_trans, pieceBorderQuads[2], x + width + 12, y + height + 12)
  love.graphics.draw(k_tiles_trans, pieceBorderQuads[3], x + width + 12, y - 4)
  love.graphics.draw(k_tiles_trans, pieceBorderQuads[4], x - 4, y + height + 12)
end
