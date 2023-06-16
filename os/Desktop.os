local FilePath
local UserPath
local ShortcutsPath
local DocumentsPath
 
local Windows = {}--script,id,title,settings,x,y,w,h
local Items = {}
local DeskItems = {}
local Notifications = {}
local Buttons = {}
local Videos = 0
local Window_Entities = {}--(windowid).(entityid),text,path,action,w,h,wx,wy
local Popup = {false,1,1,{},nil}
local DesktopDraw = true
local FullScreen = false

local Layers = {false,false,false,false}--desktop,shortcuts,windows,taskbar
local w, h = term.getSize()
 
function GetPaths()
local references = {{"Files"},{"User"},{"Desktop"},{"Documents"}}
local file = fs.open("system/directory.sys","r")
local Content
repeat
    Content = file.readLine()
    if Content ~= nil then
        for i = 1, #references do
            if string.find(string.sub(Content,1,string.find(Content,"=")),references[i][1]) ~= nil then references[i][2] = string.sub(Content,string.find(Content,"=")+1,string.len(Content)) end
        end
    end
until Content == nil
file.close()
FilePath = references[1][2]
UserPath = references[2][2]
ShortcutsPath = references[3][2]
DocumentsPath = references[4][2]
end
 
local function Clear()
term.clear()
term.setCursorPos(1,1)
end
 
function GetItems()
local List = fs.list(ShortcutsPath)
local file
local Name
local Path
local Settings
local Image
for i = 1, #List do
    file = fs.open(fs.combine(ShortcutsPath,List[i]),"r")
    Name = file.readLine()
    Path = file.readLine()
    Settings = file.readLine()--blank,blank,blank,pinnedtotaskbar
    Image = file.readLine()
    local SET = {textutils.unserialize(Settings)}
    if Name ~= nil and SET[4] == true then Items[#Items + 1] = {Name,Path,Image} end
    file.close()
end

GetDesktop()
end
 
function GetDesktop()
local List = fs.list(ShortcutsPath)
local file
local Name
local Path
local Settings
local Image
for i = 1, #List do
    file = fs.open(fs.combine(ShortcutsPath,List[i]),"r")
    Name = file.readLine()
    Path = file.readLine()
    Settings = file.readLine()--blank,blank,blank,pinnedtotaskbar
    Image = file.readLine()
    if Name ~= nil then DeskItems[#DeskItems+ 1] = {Name,Path,Image} end
    file.close()
end
 
end

function CreateWID()
local T = 1
if #Windows > 0 then T = Windows[#Windows][2] + 1 end
return T
end

function OpenPopup(x,y,details)
local Options = {}
if details[2] == "file" then
    Options = {"open","open loc","properties","delete"}
end
Popup = {true,x,y,Options,details[1]}
end
 
function CheckEvent(E,a,b,c,d,e,f)
local i
Pass = false
for j = 1, #Windows do
    if Windows[j][1] == a then i = j end
end
if E == "application" then
    Pass = true
    if a == "load" then
        Windows[#Windows+1]={b,CreateWID(),c,d,1,1,20,20}
    elseif a == "data" then
        local ET = c
        local I = #Window_Entities
        for i = 1, #ET do
            Window_Entities[I+i] = {}
        end
    elseif a == "request" then

    end
elseif E == "windowFullscreen" then
    if b == true then FullScreen = true Windows[i][6] = true end
    Pass = true
elseif E == "windowVideoUpdate" then
    UpdateItem(i,b,"video",c)
    Pass = true
elseif E == "mouse_click" then
    if CheckWindows(b,c) == true then Pass = true end
elseif E == "mouse_drag" then
    GetDragWindow(b,c)
    Pass = true
elseif E == "modem_message" then
    Notifications[#Notifications + 1] = {"message",b,c,d,e}
    Pass = true
end
return Pass
end
 
function Event()
local Pass = false
while true do
    Pass = false
    os.startTimer(3)
    local event, a, b, c, d, e, f= os.pullEvent()
    Pass = CheckEvent(event,a,b,c,d,e,f)
    if event == "timer" and Pass == false then
        drawFrame()
    elseif Pass == true then
        --updated
    end
end
end
 
function UpdateItem(win,item,set,t)
local I = 3
local J
if set == "video" then
    I = 3
end
for i = 1, #Windows[win][5] do
    if Windows[win][5][i][2] == item then J = i end
end
Windows[win][5][J][I] = set
end
 
function GetDragWindow(x,y)
 
local I = 1
for i = 1, #Windows do
    if Windows[i][6] == true and Windows[i][7] == false then
        if x >= Windows[i][2][1] + 1 and x < (Windows[i][2][1] + Windows[i][3]) - 2 and y == Windows[i][2][2] then DragWindow(i,x,y) elseif y == Windows[i][2][2] + Windows[i][4] and x == Windows[i][2][1] + Windows[i][3] then ResizeWindow(i) end
    end
end
end
 
function ResizeWindow(I)
while true do
    local event, a, b, c = os.pullEvent()
    if event == "mouse_up" then
        break
    elseif event == "mouse_drag" then
        Windows[I][3] = b - Windows[I][2][1]
        Windows[I][4] = c - Windows[I][2][2]
    end
end
end
 
function DragWindow(I,x1,y1)
local x, y
local x2 = x1 - Windows[I][2][1]
while true do
    local event, a, b, c = os.pullEvent()
    if event == "mouse_up" then
        break
    elseif event == "mouse_drag" then
        Windows[I][2] = {b - x2,c}
        x, y = b, c
    end
end
if x == Windows[I][2][1] + Windows[I][3] and y == Windows[I][2][2] then Windows[I] = nil end
end
 
function CheckWindows(x,y)--need to update Window Interaction Variables
local I = 3
 
local Found = false
for i = 1, #Items do
    if x >= I and x <= I + 2 and y >= h - 2 then
        for t = 1, #Windows do
            if Windows[t][1] == Items[i][2] then Windows[t][6] = true Found = true end
        end
        if Found == false then Found = true shell.run("os/ProgramReader.os",Items[i][2],"onCreation") end
    end
    I = I + 5
end
if Found == false then
    for i = 1, #Windows do
        if Windows[i][6] == true then
            local X1, Y1, W1, H1 = Windows[i][2][1], Windows[i][2][2], Windows[i][3], Windows[i][4]
            if Windows[i][7] == true then X1 = 1 Y1 = 1 W1 = w - 1 H1 = h - 2 end
            if x >= Windows[i][2][1] and x <= Windows[i][2][1] + Windows[i][3] and y >= Windows[i][2][2] + 1 and y <= Windows[i][2][2] + Windows[i][4] then
                for c = 1, #Windows[i][5] do
                    if Windows[i][5][c][1] == "button" and y == Windows[i][2][2] + Windows[i][5][c][5] and x >= Windows[i][2][1] + Windows[i][5][c][4] and x <= (Windows[i][2][1] + Windows[i][5][c][4]) + string.len(Windows[i][5][c][2]) then Found = true shell.run(Windows[i][5][c][3],Windows[i][5][c][2]) end
                end
            end
            if x == (X1 + W1) - 2 and y == Y1 then Windows[i][6] = false Found = true end
            if x == (X1 + W1) - 1 and y == Windows[i][2][2] then
                if Windows[i][7] == true then Windows[i][7] = false else Windows[i][7] = true end
                Found = true
            end
            if x == X1 + W1 and y == Y1 then Windows[i] = nil Found = true end
 
        else
            if x >= I and x <= I + 2 and y >= h - 2 then Windows[i][6] = true Found = true end
            I = I + 5
        end
    end
end
if Found == false and DesktopDraw == true then
    local X = 2
    local Y = 2
    local Blocked = false
    for i = 1, #DeskItems do
        Blocked = false
        for i2 = 1, #Windows do
            if X >= Windows[i2][5] and X <= Windows[i2][5] + Windows[i2][7] and Y >= Windows[i2][6] and Y <= Windows[i2][6] + Windows[i2][8] then Blocked = true end
        end
        if x >= X and x <= X + 3 and y >= Y and y <= Y + 3 and Blocked == false then Found = true shell.run("os/ProgramReader.os",DeskItems[i][2],"call","onCreation") shell.run("os/ProgramReader.os",DeskItems[i][2],"call","onStart") end
        if X + 8 < w then X = X + 6 else X = 2 Y = Y + 5 end
    end
end
Found = true
if Found == false then
    for i = 1, #Buttons do
        if y == Windows[Buttons[i][1]][2][2] + Buttons[i][5] and x >= Windows[Buttons[i][1]][2][1] + Buttons[i][4] and x <= Windows[Buttons[i][1]][2][1] + Buttons[i][4] + 5 then shell.run("os/ProgramReader.os","call",CA,Window_Entities[i][1],"click") end
    end
end
return Found
end
 
function DrawPopup()
term.setBackgroundColor(colors.white)
term.setCursorPos(Popup[2],Popup[3])
for i = 1, #Popup[4] do
    term.write(Popup[4][i])
    term.setCursorPos(Popup[2],Popup[3] + i)
end
end
 
function CheckPopup(x,y)
local R = false
local Cords = {}
for i = 1, #Popup[4] do
    Cords[i] = {Popup[2],Popup[2] + string.len(Popup[4][i]),Popup[3] - 1 + i, Popup[4][i]}
end
for i = 1, #Cords do
    if x >= Cords[i][1] and x <= Cords[i][2] and y == Cords[i][3] then R = Cords[i][3] end
end
Popup[1] = false
if R == "open" then
 
elseif R == "open loc" then
    shell.run("FInav","start",Popup[5])
elseif R == "properties" then
 
end
return R
end
 
function DrawTaskbar()
if FullScreen == false then
paintutils.drawFilledBox(1,h-1,w,h-1,colors.gray)
paintutils.drawFilledBox(1,h,w,h,colors.lightGray)
local x = 3
local Tabs = {}
for i = 1, #Items do
    paintutils.drawFilledBox(x, h -2, x + 2, h, colors.white)
    Tabs[i] = 0
    x = x + 5
end
local Found = false
for i = 1, #Windows do
    Found = false
    if Windows[i][6] == false then
        for I = 1, #Items do
            if Windows[i][1] == Items[I][1] then Tabs[I] = Tabs[I] + 1 Found = true end
        end
        if Found == false then
            paintutils.drawFilledBox(x, h-2, x + 2, h, colors.yellow)
            x = x + 5
        end
    end
end
x = 3
term.setBackgroundColor(colors.lightGray)
for i = 1, #Tabs do
    term.setCursorPos(x, h)
    if Tabs[i] > 0 then
        term.write(Tabs[i])
    end
    x = x + 5
end
if #Notifications > 0 then paintutils.drawPixel(w,h,colors.red) end
term.setBackgroundColor(colors.black)
end
end
 
function drawDesktop()
paintutils.drawFilledBox(1,1,w,h-2,colors.black)
DesktopDraw = true
for i = 1, #Windows do
    if Windows[i][7] == true and Windows[i][6] == true then DesktopDraw = false end
end
if DesktopDraw == true then
local y = 2
local x = 2
for i = 1, #DeskItems do
    paintutils.drawFilledBox(x,y,x + 3, y + 3, colors.blue)
    if x + 8 < w then x = x + 6 else x = 2 y = y + 5 end
end
end
term.setBackgroundColor(colors.black)
end
 
function Draw()
    term.setBackgroundColor(colors.black)
    local I = 1
    term.setTextColor(colors.black)
    local Cords = {}
    for i = 1, #Windows do
        if 1 == 1 then
        local X1, Y1, W1, H1 = Windows[i][5], Windows[i][7], Windows[i][6], Windows[i][8]
            if Windows[i][12] == true then X1 = 1 Y1 = 1 W1 = w - 1 H1 = h - 2 end--need to make cooperate with windows settings
            paintutils.drawFilledBox(X1,Y1,X1 + W1,Y1 + H1,colors.white)
            paintutils.drawBox(X1,Y1,X1 + W1, Y1 + H1, colors.gray)
            paintutils.drawBox(X1,Y1,X1 + W1 - 2,Y1,colors.lightGray)
            paintutils.drawPixel(X1 + W1, Y1,colors.red)
            paintutils.drawPixel((X1 + W1) - 2, Y1, colors.blue)
            paintutils.drawPixel((X1 + W1) - 1, Y1, colors.yellow)
            term.setCursorPos(X1,Y1)
            term.setBackgroundColor(colors.lightGray)
            term.write(Windows[i][3])
            term.setBackgroundColor(colors.white)
        end
    end
end
 
function VideoPlayer(Window,Item)
local List = fs.list(Windows[Window][5][Item][3])
local Image = paintutils.loadImage(fs.combine(Windows[Window][5][Item][3],List[Windows[Window][5][Item][4]]))
paintutils.drawImage(Image,Windows[Window][2][1] + Windows[Window][5][Item][5], Windows[Window][2][2] + Windows[Window][5][Item][6])
if Windows[Window][5][Item][4] < #List then
    Windows[Window][5][Item][4] = Windows[Window][5][Item][4] + 1
else
    Videos = Videos - 1
    if Windows[Window][8] ~= nil then shell.run(Windows[Window][8],Windows[Window][5][Item][2]) end
    Windows[Window][5][Item] = nil
end
end

function drawFrame()
local a, b = term.getSize()
if a ~= w or b ~= h then Clear() end
if Layers[1] == true then drawDesktop() end
if Layers[3] == true then Draw() end
if Layers[4] == true then DrawTaskbar() end
if Layers[5] == true then DrawPopup() end
end

Layers = {true,true,true,true,true}
Clear()
GetPaths()
GetItems()
drawFrame()
Event()
