Logger = {}

Logger.___bclib = function
    Logger.eLevels = bclib.Enum.Create("TRACE DEBUG INFO WARNING ERROR FATAL")
end function

Logger.Create = function(destination=null, writeMode="w")
    instance = new self
    instance.memory = []
    instance.destination = destination
    instance.writeMode = writeMode
    if instance.destination isa string then
        f = file.open(instance.destination, instance.writeMode)
        if f then
            instance.path = instance.destination
            instance.destination = f
        else
            return null
        end if
    else if not instance.destination isa TextDisplay or not instance.destination == null then
        return null
    end if
    instance.filterData = {}
    return instance
end function

Logger.Make = @Logger.Create

Logger.filter = function(self, criteria, bExclude)
    self.filterData = {}
    if not criteria isa list then criteria = [criteria]
    //for n in self.eLevels.ids(true)
    //    self.filterData[n] = bInclude == true
    if bExclude then
        for x in criteria
            self.filterData[x] = bExclude == true
        end for
    else
        for n in self.eLevels.ids(true)
            self.filterData[n] = bExclude == true
            for x in criteria
                self.filterData[n] = not bExclude == true
                break
            end for
        end for
    end if
    return self
end function

Logger.filterIn = function(self, criteria)
    return self.filter(criteria, false)
end function

Logger.filterOut = function(self, criteria)
    return self.filter(criteria, true)
end function

Logger.log = function(self, msg, level=null)
    if level == null then level = self.eLevels.INFO
    if not self.filterData.get(level) or not self.filterData[level] then
        if self.destination == null then
            self.memory.push {"time": time, "msg":msg, "level":level}
        else if self.destination isa TextDisplay then
            self.destination.print self.format(msg, level)
        else if self.destination isa FileHandle then
            self.destination.write self.format(msg, level)
        end if
    end if
end function

Logger.trace = function(self, msg)
    self.log msg, Logger.eDefaultLevels.TRACE
end function

Logger.debug = function(self, msg)
    self.log msg, Logger.eDefaultLevels.DEBUG
end function

Logger.info = function(self, msg)
    self.log msg, Logger.eDefaultLevels.INFO
end function

Logger.warn = function(self, msg)
    self.log msg, Logger.eDefaultLevels.WARNING
end function

Logger.error = function(self, msg)
    self.log msg, Logger.eDefaultLevels.ERROR
end function

Logger.fatal = function(self, msg)
    self.log msg, Logger.eDefaultLevels.FATAL
end function

Logger.format = function(self, msg, level)
    return "[" + time + "] : [" + self.eLevels.getName(level) + "] " + msg + char(10)
end function

Logger.flush = function(self)
    if self.destination isa FileHandle then
        self.destination.close
        if self.writeMode == "w" or self.writeMode == "a" then
            newWriteMode = "a"
        else if self.writeMode == "w+" or self.writeMode == "r+" or self.writeMode == "a+" then
            newWriteMode = "a+"
        else
            newWriteMode = "a"
        end if
        self.destination = file.fopen(self.path, newWriteMode)
    else if self.destination == null then
        self.memory = []
    end if
end function

Logger.getMemory = function(self)
    return self.memory
end function

Logger.deinit = function(self, engine)
    if self.destination isa FileHandle then self.destination.close
end function

return Logger