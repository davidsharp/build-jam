require 'menu-scene'
require 'match-scene'

gameState = {
  scene = "menu"
}

function love.load()
  menuScene.set()
end

-- love functions set by scene (routing in functions might be better?)
