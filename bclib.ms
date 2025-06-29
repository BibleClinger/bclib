bigImport = function(directInput)
    env.importPaths.insert 0, "/usr/lib/bclib"
    env.importPaths.insert 1, "/usr2/lib/bclib"

    import "Enum"
    import "TextLabel"

    if directInput then // Invoked by script
        globals.bclib = {}
        globals.bclib.Enum = Enum
        globals.bclib.TextLabel = TextLabel
    else // Invoked by import directive
        outer.Enum = Enum
        outer.TextLabel = TextLabel
    end if

    env.importPaths.remove 0
    env.importPaths.remove 0
    
    outer.remove "bigImport"
end function

bigImport (locals == globals)