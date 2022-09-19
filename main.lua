require 'menu-scene'
require 'match-scene'

canvas = love.graphics.newCanvas(400, 240)

gameState = {
  scene = "menu"
}

function love.load()
  love.mouse.setVisible(false)
  -- makes the pixels nice and square, rather than mushy scaled blobs
  love.graphics.setDefaultFilter( "nearest" )
  font = love.graphics.newFont( 'assets/MatchupPro/MatchupPro.ttf', 20 )
  love.graphics.setFont(font)
  menuScene.set()
end

-- love functions set by scene (routing in functions might be better?)
