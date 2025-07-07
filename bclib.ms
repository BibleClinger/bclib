import "importUtil" // Dependency
ensureImport("mapUtil") // Dependency

bigImport = function(directInput)
    env.importPaths.insert 0, "/usr/lib/bclib"
    env.importPaths.insert 1, "/usr2/lib/bclib"

    import "Enum"
    import "TextLabel"
    import "Functions"
    import "Timer"
    import "Engine"

    blackmap = {"blackmap":1, "directInput":1, "_":1} // Oddities included in locals for some reason (and itself)

    if directInput then // Invoked by script
        globals.bclib = {}
        for e in locals.indexes
            if not blackmap.hasIndex(e) then globals.bclib[e] = locals[e]
        end for
    else // Invoked by import directive
        for e in locals.indexes
            if not blackmap.hasIndex(e) then outer[e] = locals[e]
        end for
    end if

    env.importPaths.remove 0
    env.importPaths.remove 0
    outer.remove "bigImport"
end function

bigImport (locals == globals)