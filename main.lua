Timer = require 'libraries/hump/timer'
sti = require 'libraries/sti'

require 'menu-scene'
require 'match-scene'
require 'overworld-scene'
require 'settings-scene'
require 'util'
require 'box'
require 'player'
require 'jukebox'
require 'item'
require 'drawBuilding'

debug = false

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

  ground_floor_outer = love.graphics.newImage('assets/building-bits/g-floor.png')
  other_floor_outer = love.graphics.newImage('assets/building-bits/other-floor.png')

  player_tile = love.graphics.newImage('assets/1BITCanariPackTopDown/SPRITES/HEROS/spritesheets/HEROS1bit_Adventurer Idle D.png')

  tileMap = {
    -- match pieces
    brick1 = {sheet=k_tiles,quad=getTile(k_tiles,6,13)},
    brick2 = {sheet=k_tiles,quad=getTile(k_tiles,7,15)},
    brick3 = {sheet=k_tiles,quad=getTile(k_tiles,10,17)},
    bomb = {sheet=k_tiles_trans,quad=getTile(k_tiles,45,9)},
    spark = {sheet=k_tiles_trans,quad=getTile(k_tiles,36,11)},
    explosion = {sheet=k_tiles_trans,quad=getTile(k_tiles,37,11)},
    dust1 = {sheet=k_tiles_trans,quad=getTile(k_tiles,28,12)},
    dust2 = {sheet=k_tiles_trans,quad=getTile(k_tiles,29,12)},
    dust3 = {sheet=k_tiles_trans,quad=getTile(k_tiles,30,12)},
    dust4 = {sheet=k_tiles_trans,quad=getTile(k_tiles,31,12)},
    dust = {sheet=k_tiles_trans,quad=getTile(k_tiles,31,12)}, -- multiple stages?
    null = {sheet=k_tiles_trans,quad=getTile(k_tiles,35,12)},
    -- overworld items
    stairsUp = {sheet=tiles,quad=getTile(tiles,9,6)},
    stairsDown = {sheet=tiles,quad=getTile(tiles,9,11)},
    door = {sheet=tiles, quad=getTile(tiles,1,0)},
    person = {sheet=k_tiles_trans, quad=getTile(k_tiles,25,0)},
    bloke = {sheet=k_tiles_trans, quad=getTile(k_tiles,29,1)},
    bloke_face = {sheet=k_tiles_trans, quad=getTile(k_tiles,26,10)},
    man = {sheet=k_tiles_trans, quad=getTile(k_tiles,27,1)},
    man_face = {sheet=k_tiles_trans, quad=getTile(k_tiles,23,10)},
    woman = {sheet=k_tiles_trans, quad=getTile(k_tiles,26,1)},
    woman_face = {sheet=k_tiles_trans, quad=getTile(k_tiles,25,10)},
    oldMan = {sheet=k_tiles_trans, quad=getTile(k_tiles,25,4)},
    oldMan_face = {sheet=k_tiles_trans, quad=getTile(k_tiles,27,10)},
    player = {sheet=player_tile, quad=getTile(player_tile,0,0)}
  }

  frame_tiles = love.graphics.newImage('assets/frames.png')
  frames = {
    screw = {x=8,y=7},
    speech = {x=11,y=6}
  }

  sfx = {
    land = love.audio.newSource( 'assets/1BITCanariPackTopDown/SFX/Attack02.wav', 'static'),
    explode = love.audio.newSource( 'assets/1BITCanariPackTopDown/SFX/Hurt01.wav', 'static'),
    clear = love.audio.newSource( 'assets/1BITCanariPackTopDown/SFX/Pickup01.wav', 'static'),
    stairs = love.audio.newSource( 'assets/1BITCanariPackTopDown/SFX/Land01.wav', 'static'),
  }
  sfx.land:setVolume(0.4)
  sfx.explode:setVolume(0.4)
  sfx.clear:setVolume(0.3)

  jukebox.init()

  menuScene.set()
end

-- love functions set by scene (routing in functions might be better?)
