require 'menu-scene'
require 'match-scene'
require 'util'

gameState = {
  scene = "menu"
}

function love.load()
  love.mouse.setVisible(false)
  -- makes the pixels nice and square, rather than mushy scaled blobs
  love.graphics.setDefaultFilter( "nearest" )
  font = love.graphics.newFont( 'assets/MatchupPro/MatchupPro.ttf', 16 )
  love.graphics.setFont(font)

  tiles = love.graphics.newImage('assets/1BITCanariPackTopDown/TILESET/PixelPackTOPDOWN1BIT.png')

  menuScene.set()
end

-- love functions set by scene (routing in functions might be better?)
