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
end

function jukebox.start(track)
  if track then
    volumes[track] = 0.5
    music[track]:stop()
    music[track]:play()
    currentTrack = currentTrack or track
  end
  -- TODO else? else play current?
end

function jukebox.switchTrack(to)
  currentTrack = to
  Timer.tween(1, volumes, {
    game = (to == 'game' and 0.5 or 0.0),
    goofy = (to == 'goofy' and 0.5 or 0.0)
  }, 'linear')
  --[[
  if currentTrack then jukebox.fadeOut(currentTrack) end
  jukebox.fadeIn(to)
  ]]
end

--[[
function jukebox.fadeOut(track)
    volumes[track] = 0.5
    Timer.tween(5, volumes[track], 0.0, 'in-out-quad',function() music[game]:setVolume(volumes[track]) end)
end

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
