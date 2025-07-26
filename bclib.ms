import "importUtil" // Dependency
ensureImport("mapUtil") // Dependency

bigImport = function(directInput)
    env.importPaths.insert 0, "/usr/lib/bclib"
    env.importPaths.insert 1, "/usr2/lib/bclib"

    libraries = [
        "Enum",
        "Logger",
        "TextLabel",
        "Functions",
        "Timer",
        "Engine",
        "Audio",
        "Machine",
        "VideoSprite",
    ]

    globals.bclib = {}
    for lib in libraries
        import lib
        globals.bclib[lib] = locals[lib]
        if globals.bclib[lib].get("___bclib") then globals.bclib[lib].___bclib
        if not directInput then outer[lib] = locals[lib] // Invoked by import directive
    end for

    env.importPaths.remove 0
    env.importPaths.remove 0
    outer.remove "bigImport"
end function

bigImport (locals == globals)