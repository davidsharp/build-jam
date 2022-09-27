-- util for drawing a box with a sprite border, with an _internal_ x/y/height/width
-- width and height are specified in 16x16 squares, rather than by pixel!
--  perhaps x/y should be too

function box(x,y,w,h,border)
  local width = (w * 16)
  local height = (h * 16)
  local frame_x = frames.screw.x
  local frame_y = frames.screw.y
  boxBorderQuads = boxBorderQuads or {
    tl = love.graphics.newQuad((frame_x * (8*3)), (frame_y * (8*3)), 8, 8, frame_tiles),
    br = love.graphics.newQuad((frame_x * (8*3))+16, (frame_y * (8*3))+16, 8, 8, frame_tiles),
    tr = love.graphics.newQuad((frame_x * (8*3))+16, (frame_y * (8*3)), 8, 8, frame_tiles),
    bl = love.graphics.newQuad((frame_x * (8*3)), (frame_y * (8*3))+16, 8, 8, frame_tiles),
    l = love.graphics.newQuad((frame_x * (8*3)), (frame_y * (8*3))+8, 8, 8, frame_tiles),
    r = love.graphics.newQuad((frame_x * (8*3))+16, (frame_y * (8*3))+8, 8, 8, frame_tiles),
    t = love.graphics.newQuad((frame_x * (8*3))+8, (frame_y * (8*3)), 8, 8, frame_tiles),
    b = love.graphics.newQuad((frame_x * (8*3))+8, (frame_y * (8*3))+16, 8, 8, frame_tiles)
  }
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('fill',x,y,width,height)
  love.graphics.setColor(1,1,1)
  love.graphics.draw(frame_tiles, boxBorderQuads['tl'], x - 8, y - 8)
  love.graphics.draw(frame_tiles, boxBorderQuads['br'], x + width, y + height)
  love.graphics.draw(frame_tiles, boxBorderQuads['tr'], x + width, y - 8)
  love.graphics.draw(frame_tiles, boxBorderQuads['bl'], x - 8, y + height)
  for i=0,(w*2)-1,1 do
    love.graphics.draw(frame_tiles, boxBorderQuads['l'],x - 8, y + (i*8))
    love.graphics.draw(frame_tiles, boxBorderQuads['r'],x + width, y + (i*8))
  end
  for i=0,(w*2)-1,1 do
    love.graphics.draw(frame_tiles, boxBorderQuads['t'],x + (i*8), y - 8)
    love.graphics.draw(frame_tiles, boxBorderQuads['b'],x + (i*8), y + height)
  end
end
