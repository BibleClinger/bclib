VideoSprite = new Sprite

VideoSprite.Create = function(frames, audio, fps=60)
    if frames == null or frames isa str then return self.Load(frames, audio) // Interpret as file

    instance = new VideoSprite
    instance.sprite = null
    instance.frames = frames
    //if audio isa list then instance.audio = audio else instance.audio = [audio]
    instance.audio = audio
    instance.fps = fps
    return instance
end function

VideoSprite.Make = @VideoSprite.Create

VideoSprite.Load = function(directory, prefix)
    instance = new VideoSprite
    if not directory then directory = file.curdir

    instance.frames = []
    instance.audio = null
    instance.fps = 60
    instance.loop = false

    fileNames = file.children(directory)
    print "Loading frames..."
    for f in fileNames
        if f.indexOf(prefix) == 0 then
            // print "Found filename " + f
            ext = f[-4:].upper
            if ext == ".PNG" or ext == ".JPEG" or ext == ".JPG" or ext == ".TGA" then
                instance.frames.push file.loadImage(directory + "/" + f)
            else if ext == ".WAV" or ext == ".OGG" then
                //instance.audio.push file.loadSound
                instance.audio = file.loadSound(directory + "/" + f)
            end if
        end if
    end for
    instance.frames.sort("name") // sort by name
    // if instance.audio then instance.audio.sort("name") // sort by name
    if instance.frames.len == 0 then return null
    text.clear
    return instance
end function

VideoSprite.play = function(self, delta)
    self.curFrame = 0
    self.durationCurrentFrame = self.getDurationFrame
    self.isPlaying = true
    self.timePassed = 0
    self.loop = false
end function

VideoSprite.pause = function
    // Can't implement exactly, since there's no way to pause and resume audio.
end function

VideoSprite.stop = function(self, delta)
    self.curFrame = 0
    self.durationCurrentFrame = self.getDurationFrame
    self.isPlaying = false
    self.timePassed = 0
end function

VideoSprite.tick = function(self, delta)
    if self.isPlaying then
        if self.curFrame == 0 then
            if self.audio then self.audio.play
        end if
        self.timePassed += delta
        if self.timePassed >= self.getDurationFrame then
            self.curFrame = (self.curFrame + 1) % self.frames.len
            self.image = self.frames[self.curFrame]
            self.timePassed -= self.getDurationFrame
            if self.curFrame == 0 then
                if not self.loop then
                    self.isPlaying = false
                    if self.audio then self.audio.stop
                end if
            end if
        end if
    end if
end function

VideoSprite.getDurationFrame = function(self)
    return 1 / self.fps
end function

return VideoSprite