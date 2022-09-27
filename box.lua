-- util for drawing a box with a sprite border, with an _internal_ x/y/height/width
-- width and height are specified in 16x16 squares, rather than by pixel!
--  perhaps x/y should be too

function box(_x,_y,w,h)
  local x = _x - 8
  local y = _y - 8
  local width = (w * 16) + 16
  local height = (h * 16) + 16
  local frame_x = frames.screw.x
  local frame_y = frames.screw.y
  boxBorderQuads = boxBorderQuads or {
    love.graphics.newQuad((frame_x * (8*3)), (frame_y * (8*3)), 8, 8, frame_tiles),
    love.graphics.newQuad((frame_x * (8*3))+16, (frame_y * (8*3))+16, 8, 8, frame_tiles),
    love.graphics.newQuad((frame_x * (8*3))+16, (frame_y * (8*3)), 8, 8, frame_tiles),
    love.graphics.newQuad((frame_x * (8*3)), (frame_y * (8*3))+16, 8, 8, frame_tiles)
  }
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('fill',x,y,width+16,height+16)
  love.graphics.setColor(1,1,1)
  love.graphics.draw(frame_tiles, boxBorderQuads[1], x - 4, y - 4)
  love.graphics.draw(frame_tiles, boxBorderQuads[2], x + width + 12, y + height + 12)
  love.graphics.draw(frame_tiles, boxBorderQuads[3], x + width + 12, y - 4)
  love.graphics.draw(frame_tiles, boxBorderQuads[4], x - 4, y + height + 12)
end
