local w, h = term.getSize()

function DrawScreen()

end

function UpdateScreen()
local x = 1
local y = 1
local tByte = fs.getSize("os/files/Display.nfp")
local byte = 1
local file = fs.open("os/files/Display.nfp","r")
local Line
local Color = colors.black
repeat
    --need to see if at end of line to start new line
    --set color based off number
    term.setTextColor(Color)
    term.setBackgroundColor(Color)
until byte => tByte
end

function editPixel(x,y,color)

end

function fillColor(old,new)

end
