function drawBuilding(x,y)
  local height = 0
  for i=1,overworldScene.floors do
    love.graphics.draw(other_floor_outer,x,y + (height*32))
    height = height + 1
  end
  love.graphics.draw(ground_floor_outer,x,y + (height*32))
end