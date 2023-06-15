
--base
local Layers_Active = {false,false,false,false,false}
local Layers_Rate = {{5,0},{3,2},{2,1},{5,3},{5,4}}--target,current
local Objects = {}--x,y,layer,type,path/color,w,h
local w, h = term.getSize()

--graphics
local Desktop = {"c",colors.black}--mode,arg
local TaskBar_Shown = false
local ControlPanel_Shown = false
--refresh
local UpdateDelay = 3
local Timer


local function Start()
if Desktop[1] == "c" then
    paintutils.drawFilledBox(1,1
elseif Desktop[1] == "i" then

end
end

local function DrawLayer(l)
for i = 1, #Objects do
    if Objects[i][3] == l then
        if Objects[i][4] == "text" then term.setCursorPos(Objects[i][1],Objects[i][2]) term.write(Objects[i][5]) end
    end
end
end

Start()

while true do
    Timer = os.startTimer(UpdateDelay)
    os.queueEvent("timer")
    os.cancelTimer(Timer)
    for i = 1, #Layers_Active do
        if Layers_Active[i] == true then if Layers_Rate[i][1] > Layers_Rate[i][2] then Layers_Rate[i][2] = Layers_Rate[i][2] + 1 else Layers_Rate[i][2] = 0 DrawLayer(i) end end
    end
end
