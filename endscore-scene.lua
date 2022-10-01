-- this splash screen should have a few options
-- and maybe show progress through the building being built

endscoreScene = {
  ready = false
}

function endscoreScene.set()
  gameState.scene = "endscore"

  love.update = endscoreScene.update
  love.draw = endscoreScene.draw
  love.keypressed = endscoreScene.keypressed

  endscoreScene.load()
end

function endscoreScene.load()
  -- temporary
  jukebox.switchTrack('goofy')

  Timer.after(2,function() endscoreScene.ready = true end)
  -- reset player position and animate
  overworldScene.usePlayerPosition = false

  map = sti('maps/rooftop.lua')
  stairs = item:new({tile = tileMap['stairsDown'],position = {x=8*16,y=5*16}})
end

function endscoreScene.update(dt)
  -- tick the pseudo-random number along a bunch
  math.random()

  Timer.update(dt)
  jukebox.update(dt)
end

local world_x = 16*(12.5-5+5)
local world_y = 16*3
function endscoreScene.draw()
  love.graphics.scale(2)
  map:draw(world_x,world_y-(overworldScene.floors*32)+16,2,2)
  if stairs then stairs:draw(world_x,world_y-(overworldScene.floors*32)) end
  drawBuilding(world_x,world_y+(7*16)-(overworldScene.floors*32))
  love.graphics.draw(tileMap.player.sheet,tileMap.player.quad,world_x+16, world_y+(9*16))
  love.graphics.print("Game Over",2*16,1*16)
  love.graphics.print("Well done!",1.5*16,3*16)
  love.graphics.print("You built homes for",1.5*16,4*16)
  love.graphics.print(""..overworldScene.floors..(overworldScene.floors ~= 1 and " people" or " person"),4.5*16,5*16)
  love.graphics.print("over the course",1.5*16,6*16)
  love.graphics.print("of a fortnight!",4.5*16,7*16)

  love.graphics.print("Thanks for playing!",1.5*16,9*16)
  love.graphics.print("lots of love, Dave x",1.5*16,10*16)
end

function endscoreScene.keypressed(key)
  if endscoreScene.ready and key == 'return' then
    -- TODO, reset game here?
  end
end
