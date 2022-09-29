--memoise?
function getTile(tiles,x,y)
  local quad = love.graphics.newQuad(x * 16, y * 16, 16, 16, tiles)
  return quad
end

function split (inputstr, sep)
  if sep == nil then
     sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
     table.insert(t, str)
  end
  return t
end

function drawDebug()
  love.graphics.setColor(0,0,1)
  love.graphics.rectangle('fill',0,0,400*2,240*2)
  love.graphics.setColor(1,1,1)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end
