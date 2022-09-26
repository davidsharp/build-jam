-- "overworld", originally was gonna be,
--   but basically a description for the non-puzzle portion
--  show current room, intro "cutscene" possibly also lives here

overworldScene = {
  floor = 0,
  floors = 0,
  residents = {}
}

function overworldScene.set()
  gameState.scene = "overworld"

  love.update = overworldScene.update
  love.draw = overworldScene.draw
  love.keypressed = overworldScene.keypressed

  overworldScene.load()
end

function overworldScene.load()
  jukebox.switchTrack('goofy')
  map = sti('maps/room.lua')

  player = player:new()
end

function overworldScene.update(dt)
  Timer.update(dt)
  jukebox.update(dt)
  player:update(dt)
end

function overworldScene.draw()
  love.graphics.scale(2)
  map:draw(60,60,2,2)
  player:draw(60,60)
end

function overworldScene.keypressed(key)
end

