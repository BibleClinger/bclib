Audio = {}

// Channel should contain the following:
// Volume, pan, speed
//
// It should also contain which sounds were queued *now* so as to avoid crunching
// This feature might need to be delayed until later.

// Channel.volume
// Channel.pan
// Channel.speed
// Channel.queued[]

// Audio.channels are in this format:
// "music": {"volume":0.2, "pan":0.0, "speed":1.0}
// "sounds": {"volume":0.5, "pan":0.0, "speed":1.0}
// "voice": {"volume":0.8, "pan":0.0, "speed":1.0}

// This is still being developed.

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