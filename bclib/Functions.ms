parseMapArgs = function(mapArgs, search, default=null, remove=false)
    if mapArgs.hasIndex(search) then
        r = mapArgs[search]
    else
        r = default
    end if
    if remove then mapArgs.remove(search)
    return r
end function

importToDestination = function(lib, whereTo=null)
    import lib
    if not whereTo then whereTo = globals
    whereTo[lib] = locals[lib]
end function