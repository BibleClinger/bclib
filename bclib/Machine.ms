Machine = {"type":"Machine", "started":"false"}
State = {"type":"State"}

State.create = function(self, id)
    instance = new self
    instance.id = id
    instance.transitions = {}
    return instance
end function

State.on = function(self, event, target, guards=null, unless=null)
    if not self.transitions.get(event) then self.transitions[event] = []
    if target isa State then target = target.id
    currentTransitionRule = {"target":target, "guards":[], "unless":[]}
    if guards != null then currentTransitionRule.guards = guards
    if unless != null then currentTransitionRule.unless = unless
    self.transitions[event].push currentTransitionRule
    return self
end function

Machine.State = function(id)
    instance = new State
    instance.id = id
    instance.transitions = {}
    return instance
end function

Machine.Create = function(self, states, initialState, context=null, start=false)
    instance = new self
    instance.previousState = null
    instance.context = context
    instance.queue = []
    if states isa map then
        instance.states = states + {}
        for kv in instance.states
            instance.states[kv.key].machine = function
                return instance
            end function
        end for
    else if states isa list then
        instance.states = {}
        for s in states
            instance.states[s.id] = s
            s.machine = function
                return instance
            end function
        end for
    end if
    if instance.states.get(initialState) then
        if initialState isa State then
            instance.currentState = initialState.id
        else
            instance.currentState = initialState
        end if
        if start then
            Machine.start
        else
            @instance.raiseEvent = @instance.dummyRaiseEvent
            @instance.tick = @instance.dummyTick
        end if
        return instance
    end if
    // we return null otherwise
end function

Machine.start = function(self)
    self.started = true
    // TODO: "init" all states
    for s in self.states
        if self.states[s.key].get("init") then
            self.states[s.key].init
        end if
    end for
    if self.states[self.currentState].get("enter") then self.states[self.currentState].enter
    @self.raiseEvent = @self.validRaiseEvent
    @self.tick = @self.validTick
end function

Machine.dummyTick = function(self, dt)
    // Empty function. Does nothing
end function

Machine.validTick = function(self, dt)
    if self.states[self.currentState].get("tick") then self.states[self.currentState].tick dt
end function

Machine.dummyRaiseEvent = function(self, event, args)
    // Empty function. Does nothing
end function

Machine.validRaiseEvent = function(self, event, args)
    s = self.states[self.currentState]
    guardHappy = false
    unlessHappy = false
    if s.transitions.get(event) then
        for t in s.transitions[event]
            g = t.guards
            u = t.unless
            if not g or (s.get(g) and s[g]) then
                guardHappy = true
                if not u or (s.get(u) and s[u]) then
                    unlessHappy = true
                end if
            end if
            if guardHappy and unlessHappy then
                self.changeState t.target
                break
            end if
        end for
    end if
end function

Machine.changeState = function(self, newState)
    self.pendingState = newState
    // print "Pending state: " + self.pendingState
    if self.states[self.currentState].get("exit") then self.states[self.currentState].exit
    // print "Exited state: " + self.currentState
    self.previousState = self.currentState
    self.currentState = newState
    self.pendingState = null
    if self.states[self.currentState].get("enter") then self.states[self.currentState].enter
    // print "Entered state: " + self.currentState
end function

Machine.getPreviousState = function(self)
    return self.previousState
end function

Machine.getContext = function(self)
    return self.context
end function

Machine.setContext = function(self, context)
    self.context = context
end function

return Machine