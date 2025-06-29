TextLabel = {}

Create = function(td, column=0, row=0, maxLen=null, eraseChar=" ")
    instance = new TextLabel
    instance.td = td
    instance.row = row
    instance.column = column
    if eraseChar == null then eraseChar = " "
    if not eraseChar isa string then eraseChar = str(eraseChar)
    if eraseChar.len > 1 then eraseChar = eraseChar[0]
    instance.eraseChar = eraseChar
    // instance.lastLen = 0
    instance.lastText = ""
    instance.maxLen = maxLen
    return instance
end function

Make = @Create

TextLabel.print = function(text)
    oldRow = self.td.row
    oldColumn = self.td.column
    self.td.row = self.row 
    self.td.column = self.column

    if not text isa string then text = str(text)
    if self.maxLen != null and self.maxLen isa number and self.maxLen > 0 and text.len > self.maxLen then text = text[0:self.maxLen]

    self.td.print text, ""
    dif = text.len - self.lastText.len
    if dif < 0 then self.td.print self.eraseChar * abs(dif), ""
    self.lastText = text

    self.td.row = oldRow
    self.td.column = oldColumn
end function

TextLabel.unsafePrint = function(text)
    // Unsure if we want this exposed
end function

TextLabel.clear = function
    self.td.row = self.row 
    self.td.column = self.column
    self.td.print self.eraseChar * self.lastText.len, ""
end function

TextLabel.setOrigin = function(column, row, clear=true)
    if clear then self.clear
    self.row = row
    self.column = column
end function

TextLabel.setDisplay = function(display, clear=true)
    if clear then self.clear
    self.td = display
end function

TextLabel.move = function(column, row, clear=true)
    self.setOrigin row, column, clear
    self.td.row = self.row
    self.td.column = self.column
    self.td.print self.lastText, ""
end function