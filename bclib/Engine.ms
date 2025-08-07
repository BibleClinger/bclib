Engine = {}

Engine.Create = function(interfaces = null, context = null, doYield = true)
    instance = new self
    instance.context = context
    instance.doYield = doYield
    
    instance.interfaces = []
    instance.toDelete = []
    instance.add(interfaces)
    return instance
end function

Engine.Make = @Engine.Create

Engine.add = function(self, interfaces)
    if not @interfaces isa list then @interfaces = [@interfaces]
    for i in interfaces
        if not @i == null then
            self.interfaces.push @i
            if @i isa map and i.get("init") then i.init self
        end if
    end for
end function

Engine.remove = function(self, interfaces)
    if not @interfaces isa list then @interfaces = [@interfaces]
    for i in interfaces
        self.toDelete.push @i
    end for
end function

Engine.deinit = function(self)
    // Deinitialize all interfaces
    for i in self.interfaces
        if not @i == null and @i isa map and i.get("deinit") then i.init self
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
        if @i isa funcRef then // function
            i delta
        else // map/object
            if i.get("tick") then
                i.tick delta
            else if i.get("update") then
                i.update delta
            end if
        end if
        for d in self.toDelete
            if @d isa map and d.get("deinit") then d.deinit self
            self.interfaces.removeVal d
        end for
        self.toDelete = []
    end for
    if self.doYield then yield // 60 Hz
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

    self.deinit
end function

return Engine