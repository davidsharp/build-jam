-- music handler
jukebox = {}
volumes = {
  game = 0.0,
  goofy = 0.0
}
currentTrack = nil

function jukebox.init()
  music = {
    game = love.audio.newSource( 'assets/JDSherbett/JDSherbert - Minigame Music Pack - Corrupted Circuitry.ogg', 'stream'),
    goofy = love.audio.newSource( 'assets/JDSherbett/JDSherbert - Nostalgia Music Pack - Saturday Morning Cartoons.ogg', 'stream')
  }
  for _,track in pairs(music) do
    track:setLooping(true)
  end
end

function jukebox.start(track)
  if track then
    volumes[track] = gameState.maxVolume
    music[track]:stop()
    music[track]:play()
    currentTrack = currentTrack or track
  end
  -- TODO else? else play current?
end

function jukebox.switchTrack(to)
  local from = currentTrack
  if to == from then return end
  currentTrack = to
  Timer.tween(1, volumes, {
    game = (to == 'game' and gameState.maxVolume or 0.0),
    goofy = (to == 'goofy' and gameState.maxVolume or 0.0)
  }, 'linear',function() if from then music[from]:stop() end end)
  --[[
  if currentTrack then jukebox.fadeOut(currentTrack) end
  jukebox.fadeIn(to)
  ]]
end

function jukebox.fadeOut()
  Timer.tween(1, volumes, {
    game = 0.0,
    goofy = 0.0
  }, 'linear',function() if currentTrack then music[currentTrack]:stop() end end)
end

--[[
function jukebox.fadeIn(track)
  currentTrack = track
  volumes[track] = 0.0
  Timer.tween(5, volumes[track], 0.5, 'in-out-quad', function()
    music[game]:setVolume(volumes[track])
  end)
end
]]

function jukebox.update(dt)
    for k,v in pairs(volumes) do
      music[k]:setVolume(v)
    end
    if currentTrack then music[currentTrack]:play() end
end
