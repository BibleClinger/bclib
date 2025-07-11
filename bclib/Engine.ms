Engine = {}

Engine.Create = function(interfaces = null)
    instance = new self
    
    instance.interfaces = []
    if interfaces != null then instance.add(interfaces)

    return instance
end function

Engine.Make = @Engine.Create

Engine.add = function(self, interfaces)
    if not interfaces isa list then interfaces = [interfaces]
    for i in interfaces
        self.interfaces.push i
        if i.get("init") then i.init self
    end for
end function

Engine.remove = function(self, interfaces)
    if not interfaces isa list then interfaces = [interfaces]
    for i in interfaces
        index = self.interfaces.indexOf(i)
        if index != null then self.interfaces.remove(index)
    end for
end function

Engine.quit = function(self)
    self.active = false
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

        for i in self.interfaces
            // Tick all interfaces, and pass delta time
            if i.get("tick") then
                i.tick delta
            else if i.get("update") then
                i.update delta
            else
                print "No entry!"
            end if
            yield // 60 Hz
        end for
    end while

    // Deinitialize all interfaces
    for i in self.interfaces
        if i.get("deinit") then i.deinit self
    end for
end function

return Engine