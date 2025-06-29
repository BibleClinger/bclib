Enum = {}
Enum.inverse = null // map of inverted options
Enum.k = null // list of keys, enum names
Enum.v = null // list of values, enum indexes

Create = function(names, numericals=null)
    newEnum = new Enum
    newEnum.inverse = {}
    newEnum.k = []
    newEnum.v = []
    if names isa string then names = names.split // names must be a list
    if numericals == null then numericals = range(0, names.len-1) // numericals must be a list
    if names isa list and numericals isa list and names.len == numericals.len then
        for i in range(names.len-1)
            if not names[i] isa string or not numericals[i] isa number then return null
            newEnum[names[i]] = numericals[i]
            newEnum.k.insert 0, names[i]
            newEnum.v.insert 0, numericals[i]
            newEnum.inverse[numericals[i]] = names[i]
        end for
        return newEnum
    end if
    // return null // implied
end function

Make = @Create

Enum.names = function(self, readOnly=false)
    if readOnly then return self.k
    return self.k + [] // Clones the list
end function

Enum.ids = function(self, readOnly=false)
    if readOnly then return self.v
    return self.v + [] // Clones the list
end function

Enum.count = function(self)
    return self.k.len
end function

Enum.getName = function(self, id)
    if self.inverse.hasIndex(id) then return self.inverse[id]
    // return null // implied
end function


s = Enum.x