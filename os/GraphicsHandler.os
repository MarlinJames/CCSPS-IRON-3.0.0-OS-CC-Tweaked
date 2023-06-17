local w, h = term.getSize()

local function CombineLayers()

end
function DrawScreen()

end

function UpdateScreen()
CombineLayers()
local x = 1
local y = 1
local tByte = fs.getSize("os/files/Display_M.nfp")
local byte = 1
local file = fs.open("os/files/Display_M.nfp","r")
local tFile = fs.open("os/files/Display_textM.txt","r")
local Line = file.readLine()
local Text = tFile.readLine()
local Color = colors.black
local Char = " "
repeat
    Color = string.sub(Line,x)
    Char = string.sub(Text,x)
    term.setCursorPos(x,y)
    term.setBackgroundColor(Color)
    if Char ~= " " then if Color == 0 then term.setTextColor(colors.black) else term.setTextColor(colors.white) end term.write(Char) else term. setTextColor(Color) term.write(0) end
    byte = byte + 1
    if x == w then x = 1 y = y + 1 Line = file.readLine Text = tFile.readLine() else x = x + 1 end
until byte => tByte

file.close()
tFile.close()
end

function editPixel(x,y,color)

end

function fillColor(old,new)

end
