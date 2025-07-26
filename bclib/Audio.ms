Audio = {}

// Channel should contain the following:
// Volume, pan, speed
//
// It should also contain which sounds were queued *now* so as to avoid crunching
// This feature might need to be delayed until later.

// Channel.id ?
// Channel.volume
// Channel.pan
// Channel.speed
// Channel.queued[]
// Channel.stop
// Channel.fade?

// AudioClip.id ?
// AudioClip.snd
// AudioClip.volume
// AudioClip.pan
// AudioClip.speed
// AudioClip.isPlaying
// AudioClip.loop

// AudioClip volume * Channel volume. So if audio plays at 100%, and channel volume is 100%, we have 1*1=1. Audio plays at 100%
//  If AudioClip is designed to play at 50% volume, and channel is 100%, then 0.5*1 = 50%. Also correct.
//  If AudioClip at 50% and channel at 50%, then volume is 25%. Correct.

// Imagine a MUSIC channel, SFX channel, and VOICE channel.
// The player can adjust the channel volumes however he wants. We can even have special control interfaces for this that override the main game state machine, like directly in the engine. (Although this could be dangerous.)

// Need a proper API for making channel adjustments on the fly for audio already playing.

// Audio.channels are in this format:
// "music": {"volume":0.2, "pan":0.0, "speed":1.0}
// "sounds": {"volume":0.5, "pan":0.0, "speed":1.0}
// "voice": {"volume":0.8, "pan":0.0, "speed":1.0}

// This is still being developed.

Audio.Clip = {}

Audio.Clip.load = function(src)
    instance = new self
    instance.snd = file.loadSound(src)
    instance.loop = false
    instance._isPlaying = false
    return instance
end function

Audio.Clip.isPlaying = function(self)
    return self._isPlaying
end function

Audio.Clip.play = function(self)
    self._isPlaying = true
    self.snd.play
    if self.loop and not self.get("timer") then self.timer = bclib.Timer.Create(self.snd.duration, self, false, true)
    if self.get("timer") then self.timer.start // We start timer here in case we had a self.stop called prior
end function

Audio.Clip.onTimeout = function(self, timer)
    if self.loop then
        self.play
    else
        self._isPlaying = false
        timer.stop
    end if
end function

Audio.Clip.stop = function(self)
    self._isPlaying = false
    self.snd.stop
    if self.get("timer") then self.timer.pause // We stop calculation of replay timer
end function

Audio.Clip.tick = function(self, delta)
    if self.get("timer") then self.timer.tick delta
end function

Audio.Create = function(channels=null)
    instance = new self
    if channels == null then
        instance.channels = {"main": {"volume":1.0, "pan":0.0, "speed":1.0, "playing":[]} }
    else
        instance.channels = channels + {}
    end if
    instance.clips = {}
    return instance
end function

Audio.setChannel = function(channel)
    
end function

Audio.getChannel = function(channel)
    
end function

Audio.load = function(self, clip)
    // Load a sound file in format of {"ID":{Sound} }
    // Like "punch":{Sound}
    for kv in clip
        self.clips[kv.key] = kv.value
    end for
end function

Audio.play = function(self, clip, channel="main", allowCrunch = false)//, volume=1.0, pan=1.0, speed=1.0)
    // self.clips[clip].play self.channels[channel].volume * volume, self.channels[channel].pan * pan, self.channels[channel].speed * speed
    if allowCrunch or not self.clips[clip].isPlaying then
        self.clips[clip].play self.channels[channel].volume, self.channels[channel].pan, self.channels[channel].speed
    end if
end function

Audio.stop = function(clip, channel="main")
    // Not implemented
    s = self.clips[clip]
    s.stop
end function

Audio.fadeOut = function(clip, channel="main")
    // Not implemented
end function

Audio.incProp = function(self, property, value=0.1, channel="main")
    self.channels[channel][property] += value // TODO: we need to clamp it.
end function

Audio.decProp = function(property, value=0.1, channel="main")
    self.channels[channel][property] -= value // TODO: we need to clamp it.
end function

Audio.setProp = function(property, value=1, channel="main")
    self.channels[channel][property] = value // TODO: we need to clamp it.
end function

Audio.getProp = function(property, channel="main")
    return self.channels[channel][property]
end function

return Audio