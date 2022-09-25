Timer = require 'libraries/hump/timer'

require 'menu-scene'
require 'match-scene'
require 'util'
require 'box'
require 'jukebox'

gameState = {
  scene = "menu",
  maxVolume = 0.5,
  -- TODO - set/update Music/SFX volume
  musicVolume = 1.0,
  sfxVolume = 1.0
}

function love.load()
  love.mouse.setVisible(false)
  -- makes the pixels nice and square, rather than mushy scaled blobs
  love.graphics.setDefaultFilter( "nearest" )
  font = love.graphics.newFont( 'assets/MatchupPro/MatchupPro.ttf', 16 )
  love.graphics.setFont(font)

  tiles = love.graphics.newImage('assets/1BITCanariPackTopDown/TILESET/PixelPackTOPDOWN1BIT.png')
  k_tiles = love.graphics.newImage('assets/1bitpack_kenney_1.2/Tilesheet/monochrome_packed.png')
  k_tiles_trans = love.graphics.newImage('assets/1bitpack_kenney_1.2/Tilesheet/monochrome-transparent_packed.png')

  sfx = {
    land = love.audio.newSource( 'assets/1BITCanariPackTopDown/SFX/Attack02.wav', 'static'),
    explode = love.audio.newSource( 'assets/1BITCanariPackTopDown/SFX/Hurt01.wav', 'static'),
    clear = love.audio.newSource( 'assets/1BITCanariPackTopDown/SFX/Pickup01.wav', 'static'),
  }
  sfx.land:setVolume(0.4)
  sfx.explode:setVolume(0.4)
  sfx.clear:setVolume(0.3)

  jukebox.init()

  menuScene.set()
end

-- love functions set by scene (routing in functions might be better?)
