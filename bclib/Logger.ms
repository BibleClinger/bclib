Logger = {}

Logger.___bclib = function
    Logger.eDefaultLevels = bclib.Enum.Create("TRACE DEBUG INFO WARNING ERROR FATAL")
end function

Logger.Create = function(destination=null, defaultLevel=null, levels=null)
    instance = new self
    instance.memory = []
    instance.destination = destination
    if levels == null then levels = Logger.eDefaultLevels
    instance.eLevels = levels
    if defaultLevel == null then
        if instance.eLevels == Logger.eDefaultLevels then
            defaultLevel = Logger.eDefaultLevels.INFO
        else
            size = instance.eLevels.size
            if size > 0 then
                defaultLevel = instance.eLevels[instance.eLevels.names(true)[0]]
            else
                return null
            end if
        end if
    end if
    instance.defaultLevel = defaultLevel
    instance.filterData = {}
    return instance
end function

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

Logger.oldfilter = function(self, criteria, bInclude)
    self.filterData = {}
    //for n in self.eLevels.ids(true)
    //    self.filterData[n] = bInclude == true
        for x in criteria
            if self.eLevels[n] == x then
                self.filterData[n] = not bInclude == true
                break
            end if
        end for
    // end for
    return self
end function

Logger.filterIn = function(self, criteria)
    return self.filter(criteria, false)
end function

Logger.filterOut = function(self, criteria)
    return self.filter(criteria, true)
end function

Logger.Make = @Logger.Create

Logger.log = function(self, msg, level=null)
    if level == null then level = self.defaultLevel
    if not self.filterData.get(level) or not self.filterData[level] then
        if self.destination == null then
            self.memory.push {"time": time, "msg":msg}
        else if self.destination isa TextDisplay then
            self.destination.print self.format(msg, level)
        else if self.destination isa FileHandle then
            self.destination.write self.format(msg, level)
        else
            self.unhandledError
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

Logger.unhandledError = function(self)
    // We just scream at the TextDisplay
    print "Unhandled logging error!"
end function

Logger.format = function(self, msg, level)
    return "[" + time + "] : [" + self.eLevels.getName(level) + "] " + msg + char(10)
end function

Logger.deinit = function(self, engine)
    if self.destination isa FileHandle then self.destination.close
end function

return Logger