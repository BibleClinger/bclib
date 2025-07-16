TextLabel = {}

TextLabel.___bclib = function
    TextLabel.eJustificationType = bclib.Enum.Create("LEFT CENTER RIGHT PREFIXCENTER CENTERPREFIX")
end function

TextLabel.Create = function(column, row=null)
    if column isa number and row isa number then
        args = {"column":column, "row": row} // column, row
    else
        args = column
    end if

    if not args isa map then return null // We didn't get what we needed
    parse = @bclib.Functions.parseMapArgs // args map parser

    instance = new TextLabel
    // instance.td = parse(args, "display", globals.text)
    //instance.column = parse(args, "column", 0)
    //instance.row = parse(args, "row", 0)
    //instance.eraseChar = parse(args, "eraseChar", " ")
    //instance.terminatorChar = parse(args, "terminatorChar", "")
    //instance.color = parse(args, "color", null)
    //instance.backColor = parse(args, "backColor", null)
    //instance.maxLen = parse(args, "maxLen", -1)
    //instance.prefix = parse(args, "prefix", "")
    //text = parse(args, "text", null)

    instance.td = args.get("display", globals.text)
    instance.column = args.get("column", 0)
    instance.row = args.get("row", 0)
    instance.eraseChar = args.get("eraseChar", " ")
    instance.terminatorChar = args.get("terminatorChar", "")
    instance.color = args.get("color", null)
    instance.backColor = args.get("backColor", null)
    instance.maxLen = args.get("maxLen", -1)
    instance.prefix = args.get("prefix", "")
    instance.justification = args.get("justification", TextLabel.eJustificationType.LEFT)
    text = args.get("text", null)

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

TextLabel.Make = @TextLabel.Create

TextLabel.print = function(self, text)
    oldRow = self.td.row
    oldColumn = self.td.column

    nullMessage = text == null
    if nullMessage then
        text = ""
    else if not text isa string then
        text = str(text)
    end if
    if self.maxLen != null and self.maxLen isa number and self.maxLen > 0 and text.len > self.maxLen then text = text[0:self.maxLen]

    self.td.row = self.row 
    if self.justification == TextLabel.eJustificationType.LEFT then
        currentColumn = self.column
        previousColumn = self.column
    else if self.justification == TextLabel.eJustificationType.CENTER or self.justification == TextLabel.eJustificationType.PREFIXCENTER or self.justification == TextLabel.eJustificationType.CENTERPREFIX then
        currentColumn = self.column - floor((self.prefix.len + text.len) / 2)
        previousColumn = self.column - floor((self.prefix.len + self.lastText.len) / 2)
    else if self.justification == TextLabel.eJustificationType.RIGHT then
        currentColumn = self.column - (self.prefix.len + text.len) + 1
        previousColumn = self.column - (self.prefix.len + self.lastText.len) + 1
    else
        return // No idea how to handle other values
    end if


    self.td.column = previousColumn
    if nullMessage then
        self.td.print self.eraseChar * (self.prefix.len + self.lastText.len), self.terminatorChar
    else
        earlySpace = currentColumn - previousColumn
        if earlySpace > 0 then self.td.print self.eraseChar * earlySpace, self.terminatorChar

        if self.color then
            oldColor = self.td.color
            self.td.color = self.color
        end if

        if self.backColor then
            oldBackColor = self.td.backColor
            self.td.backColor = self.backColor
        end if

        self.td.column = currentColumn
        if self.justification == TextLabel.eJustificationType.LEFT or self.justification == TextLabel.eJustificationType.CENTER or self.justification == TextLabel.eJustificationType.PREFIXCENTER then
            self.td.print self.prefix + text, self.terminatorChar
        else if self.justification == TextLabel.eJustificationType.RIGHT or self.justification == TextLabel.eJustificationType.CENTERPREFIX then
            self.td.print text + self.prefix, self.terminatorChar
        end if

        if self.color then self.td.color = oldColor
        if self.backColor then self.td.backColor = oldBackColor

        if earlySpace < 0 then earlySpace = 0
        lateSpace = self.lastText.len - (text.len + earlySpace)
        if lateSpace > 0 then self.td.print self.eraseChar * lateSpace, self.terminatorChar
    end if

    //if not (nullMessage or text.len == 0) then self.lastText = text
    self.lastText = text

    self.td.row = oldRow
    self.td.column = oldColumn
end function

TextLabel.clear = function(ignorePrefix=false)
    if ignorePrefix then self.print "" else self.print
end function

TextLabel.setDisplay = function(self, display)
    self.clear
    self.td = display
    self.print self.lastText
end function

TextLabel.setColor = function(self, newColor)
    if newColor isa string then
        self.color = newColor
        return true
    end if
    return false
end function

TextLabel.setBackColor = function(self, newBackColor)
    if newBackColor isa string then
        self.backColor = newBackColor
        return true
    end if
    return false
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

return TextLabel