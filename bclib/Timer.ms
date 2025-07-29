Timer = {}

Timer.Create = function(seconds, callback, start=false, loop=false, context=null)
    if not @callback then return null
    instance = new self
    instance.initialTime = seconds
    instance.currentTime = seconds
    instance.callback = @callback
    instance.loop = loop
    instance.context = context
    if start then instance.start else self.active = false
    return instance
end function

Timer.Make = @Timer.Create

Timer.start = function(self)
    self.active = true
end function

Timer.pause = function(self)
    self.active = false
end function

Timer.stop = function(self, newTime=null)
    self.pause
    return self.reset(newTime)
end function

Timer.reset = function(self, newTime=null)
    if newTime != null and not newTime isa number then return false

    if newTime != null then
        self.currentTime = newTime
        self.initialTime = newTime
    else
        self.currentTime = self.initialTime
    end if
end function

Timer.isActive = function(self)
    return self.active
end function

Timer.setData = function(self, data)
    self.context = context
end function

Timer.getData = function(self)
    return self.context
end function

Timer.setContext = function(self, context)
    self.context = context
end function

Timer.getContext = function(self)
    return self.context
end function

Timer.tick = function(self, delta)
    if self.active then
        self.currentTime -= delta
        if self.currentTime <= 0 then
            self.currentTime = 0
            self.reset // We reset timers back to normal so they can be started again
            if not self.loop then
                self.pause // We pause timers that are not on a loop
            end if
            if @self.callback then
                if @self.callback isa funcRef then
                    self.callback(self)
                else if self.callback isa map and self.callback.get("onTimeout") then
                    self.callback.onTimeout(self)
                end if
            end if
        end if
    end if
end function

Timer.timeLeft = function(self)
    return self.currentTime
end function

//Timer.deinit = function(self, engine)
    //engine.remove self
//end function

return Timer