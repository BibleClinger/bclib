Engine = {}

Engine.Create = function(interfaces = null, context = null, doYield = true)
    instance = new self
    instance.context = context
    instance.doYield = doYield
    
    instance.interfaces = []
    instance.add(interfaces)
    return instance
end function

Engine.Make = @Engine.Create

Engine.add = function(self, interfaces)
    if not interfaces isa list then interfaces = [interfaces]
    for i in interfaces
        if not i == null then
            self.interfaces.push i
            if i.get("init") then i.init self
        end if
    end for
end function

Engine.remove = function(self, interfaces)
    if not interfaces isa list then interfaces = [interfaces]
    for i in interfaces
        index = self.interfaces.indexOf(i)
        if index != null then self.interfaces.remove(index)
    end for
end function

Engine.setContext = function(self, context)
    self.context = context
end function

Engine.getContext = function(self)
    return self.context
end function

Engine.quit = function(self)
    self.active = false
end function

Engine.tick = function(self, delta)
    for i in self.interfaces
        // Tick all interfaces, and pass delta time
        if i.get("tick") then
            i.tick delta
        else if i.get("update") then
            i.update delta
        end if
        if self.doYield then yield // 60 Hz
    end for
end function

Engine.run = function(self)
    self.active = true

    // Initialize all interfaces
    //for i in self.interfaces
    //    if i.get("init") then i.init self
    //end for

    // Main engine loop
    lastTime = time
    while self.active
        now = time
        delta = now - lastTime
        lastTime = now

        self.tick delta
    end while

    // Deinitialize all interfaces
    for i in self.interfaces
        if i.get("deinit") then i.deinit self
    end for
end function

return Engine