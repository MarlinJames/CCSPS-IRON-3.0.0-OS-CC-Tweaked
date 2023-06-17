local w, h = term.getSize()

local function CombineLayers_D()
local Doc = fs.open("os/files/Display_M.nfp","w")
local LINES = {}
for i = 1, #fs.list("os/files/layers") do
    local file = fs.open("os/files/layers/Display_L"..i..".nfp","r")
    local Line
    for y = 1, h do
        Line = file.readLine()
        local STR =""
        for x = 1, w do
            if string.sub(Line,x) ~= " " then STR = STR + string.sub(Line,x) else STR = STR + string.sub(LINES[y],x) end
        end
        LINES[y] = STR
    end
    file.close()
end
for i = 1, #LINES do
    Doc.writeLine(LINES[i])
end
Doc.close()
end

local function CombineLayers_T()
local Doc = fs.open("os/files/Display_textM.txt","w")
local LINES = {}
for i = 1, 4 do
    local file = fs.open("os/files/Display_T"..i..".txt","r")
    local Line
    for y = 1, h do
        Line = file.readLine()
        local STR =""
        for x = 1, w do
            if string.sub(Line,x) ~= " " then STR = STR + string.sub(Line,x) else STR = STR + string.sub(LINES[y],x) end
        end
        LINES[y] = STR
    end
    file.close()
end
for i = 1, #LINES do
    Doc.writeLine(LINES[i])
end
Doc.close()
end

function DrawScreen()

end

function UpdateScreen()
CombineLayers_D()
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

function boot()
for i = 1, #fs.list("os/files/layers") do
    local T = "os/files/layers/Display_L"..i..".nfp")
    if fs.exists(T) then fs.delete(T) end
end
local file = fs.open("os/files/layers/Display_L1.nfp","w")
local x = 1
local Line = ""
for i = 1, w*h do
    Line = Line + "0"
    if x == w then x = 1 file.writeLine(Line) Line = "" else x = x + 1 end
end
file.close()
end
