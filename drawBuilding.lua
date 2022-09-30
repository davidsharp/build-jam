function drawBuilding(x,y)
  local leftColumn = {sheet=tiles,quad=getTile(tiles,14,19)}
  local rightColumn = {sheet=tiles,quad=getTile(tiles,14,20)}
  local height = 0
  for i=1,overworldScene.floors do
    love.graphics.draw(other_floor_outer,x,y + (height*32))
    if i ~= 1 then
      love.graphics.draw(tiles,leftColumn.quad,x,y + (height*32))
      love.graphics.draw(tiles,rightColumn.quad,x + (9*16),y + (height*32))
    end
    height = height + 1
  end
  love.graphics.draw(ground_floor_outer,x,y + (height*32))
  if overworldScene.floors > 0 then
    love.graphics.draw(tiles,leftColumn.quad,x,y + (height*32))
    love.graphics.draw(tiles,rightColumn.quad,x + (9*16),y + (height*32))
  end
end