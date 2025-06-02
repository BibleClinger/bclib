bigImport = function(directInput)
    env.importPaths.insert 0, "/usr/lib/bclib"
    env.importPaths.insert 1, "/usr2/lib/bclib"

    import "Enum"

    if directInput then // Invoked by script
        globals.bclib = {}
        globals.bclib.Enum = Enum
    else // Invoked by import directive
        outer.Enum = Enum
    end if

    env.importPaths.remove 0
    env.importPaths.remove 0
    
    outer.remove "bigImport"
end function

bigImport (locals == globals)