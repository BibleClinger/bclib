TextLabel = {}

Create = function(column, row=null)
    if column isa number and row isa number then
        args = {"column":column, "row": row} // column, row
    else
        args = column
    end if

    if not args isa map then return null // We didn't get what we needed
    parse = @bclib.Functions.parseMapArgs // args map parser

    instance = new TextLabel
    instance.td = parse(args, "display", globals.text)
    instance.column = parse(args, "column", 0)
    instance.row = parse(args, "row", 0)
    instance.eraseChar = parse(args, "eraseChar", " ")
    instance.terminatorChar = parse(args, "terminatorChar", "")
    instance.color = parse(args, "color", null) // Potential future feature
    instance.backColor = parse(args, "backColor", null) // Potential future feature
    instance.maxLen = parse(args, "maxLen", -1)
    instance.prefix = parse(args, "prefix", "")
    text = parse(args, "text", null)

    if instance.eraseChar == null then
        instance.eraseChar = " "
    else if not instance.eraseChar isa string then
        instance.eraseChar = str(instance.eraseChar)
    else if instance.eraseChar.len > 1 then
        instance.eraseChar = instance.eraseChar[0]
    end if

    if instance.terminatorChar == null then
        instance.terminatorChar = ""
    else if not instance.terminatorChar isa string then
        instance.terminatorChar = str(instance.terminatorChar)
    else if instance.terminatorChar.len > 1 then
        instance.terminatorChar = instance.terminatorChar[0]
    end if

    if instance.prefix == null then
        instance.prefix = ""
    else if not instance.prefix isa string then
        instance.prefix = str(instance.prefix)
    end if

    // instance.lastLen = 0
    instance.lastText = ""

    if text != null then instance.print text
    return instance
end function

Make = @Create

TextLabel.print = function(text)
    oldRow = self.td.row
    oldColumn = self.td.column
    self.td.row = self.row 
    self.td.column = self.column

    if self.color then
        oldColor = self.td.color
        self.td.color = self.color
    end if

    if self.backColor then
        oldBackColor = self.td.backColor
        self.td.backColor = self.backColor
    end if

    nullMessage = text == null
    if nullMessage then
        text = ""
    else if not text isa string then
        text = str(text)
    end if
    if self.maxLen != null and self.maxLen isa number and self.maxLen > 0 and text.len > self.maxLen then text = text[0:self.maxLen]

    if nullMessage then
        self.td.print self.eraseChar * (self.prefix.len + self.lastText.len)
    else
        self.td.print self.prefix + text, self.terminatorChar
        dif = text.len - self.lastText.len
        if dif < 0 then self.td.print self.eraseChar * abs(dif), self.terminatorChar
    end if

    if not (nullMessage or text.len == 0) then self.lastText = text

    self.td.row = oldRow
    self.td.column = oldColumn

    if self.color then self.td.color = oldColor
    if self.backColor then self.td.backColor = oldBackColor
end function

TextLabel.clear = function(ignorePrefix=false)
    if ignorePrefix then self.print "" else self.print
end function

TextLabel.setDisplay = function(self, display)
    self.clear
    self.td = display
    self.print self.lastText
end function

TextLabel.setPrefix = function(self, prefix)
    self.clear
    self.prefix = prefix
    if self.prefix == null then
        self.prefix = ""
    else if not self.prefix isa string then
        self.prefix = str(prefix)
    end if
    self.print self.lastText
end function

TextLabel.move = function(self, column, row)
    self.clear
    self.column = column
    self.row = row

    oldRow = self.td.row
    oldColumn = self.td.column

    self.td.row = self.row
    self.td.column = self.column

    self.td.print self.lastText, ""

    self.td.row = oldRow
    self.td.column = oldColumn
end function