Enum = {}

Enum.Create = function(names, numericals=null)
    newEnum = new self
    newEnum._inverse = {} // map of inverted options
    newEnum._k = [] // list of keys, enum names
    newEnum._v = [] // list of values, enum indexes
    if names isa string then names = names.split // names must be a list
    if numericals == null then numericals = range(0, names.len-1) // numericals must be a list
    if names isa list and numericals isa list and names.len == numericals.len then
        for i in range(names.len-1)
            if not names[i] isa string or not numericals[i] isa number then return null
            newEnum[names[i]] = numericals[i]
            newEnum._k.insert 0, names[i]
            newEnum._v.insert 0, numericals[i]
            newEnum._inverse[numericals[i]] = names[i]
        end for
        return newEnum
    end if
    // return null // implied
end function

Enum.Make = @Enum.Create

Enum.names = function(self, readOnly=false)
    if readOnly then return self._k
    return self._k + [] // Clones the list
end function

Enum.ids = function(self, readOnly=false)
    if readOnly then return self._v
    return self._v + [] // Clones the list
end function

Enum.count = function(self)
    return self._k.len
end function

Enum.getName = function(self, id)
    if self._inverse.hasIndex(id) then return self._inverse[id]
    // return null // implied
end function

return Enum