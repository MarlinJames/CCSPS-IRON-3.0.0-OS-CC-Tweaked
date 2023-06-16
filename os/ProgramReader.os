local arg = {...}
--references
local Calls = {"onCreation","onStart","onInteract","onKeyPress","onMessage"}
local Functs = {"entity.create","entity.delete","entity.edit"}
--variables
local entities = {}
local callbacks ={}
local functions = {}
 
local Pass = {}
 
local function CheckFormula(formula)
local Res = false
if formula == "n" then Res = true end
return Res
end
 
local function RunEvent(event)
 
local Type = string.sub(event,1,string.find(event,"%.")-1)
 
local Op = string.sub(event, string.find(event,"%.")+1,string.find(event,"%<")-1)
local ARGS = {}
local I = 1
local ag = {}
repeat
    if I == 1 then ARGS[I] = string.find(event,"%<") elseif string.find(event,"%,",ARGS[I-1]+1) ~= nil then ARGS[I] = string.find(event,"%,",ARGS[I-1]+1) else ARGS[I] = string.find(event,"%>",ARGS[I-1]+1) end
    I = I + 1
until string.find(event,"%,",ARGS[I-1]+1) == nil
 
for i = 2, #ARGS do
    ag[#ag][i] = string.sub(event,ARGS[i-1]+1,ARGS[i]-1)
end
 
os.queueEvent("application","request",ag[1],ag[2],ag[3])
end
 
local function runFunct(name)
for i = 1, #functions do
    if functions[i][1] == name then if CheckFormula(functions[i][2]) == true then RunEvents(functions[i][3]) end end
end
end
 
local function ReadFunction(line)
 
local Call = string.sub(line, string.find(line,"%."),string.find(line,"%(")-1)
local ARGS = {}
local I = 1
 
 
repeat
    if I == 1 then ARGS[I] = string.find(line,"%(") else ARGS[I] = string.find(line,"%,",ARGS[I-1]+1) end
    I = I + 1
until string.find(line,"%,",ARGS[I-1]+1) == nil
functions[#functions+1] = {}
functions[#functions][1] = Call
for i = 2, #ARGS do
    functions[#functions][i] = string.sub(line,ARGS[i-1]+1,ARGS[i]-1)
end
 
end
 
local function ReadCallBack(line)
local Call = string.sub(line,1,string.find(line,"%(")-1)
local ARGS = {}
local I = 1
 
 
repeat
    if I == 1 then ARGS[I] = string.find(line,"%(") else ARGS[I] = string.find(line,"%,",ARGS[I-1]+1) end
    I = I + 1
until string.find(line,"%,",ARGS[I-1]+1) == nil
if Call == "onCreation" then--minimizable,fullscreen,title
    callbacks[#callbacks+1] = {"onCreation",ARGS[1],ARGS[2],ARGS[3]}
elseif Call == "onStart" then--background,entitypath
    callbacks[#callbacks+1] = {"onStart",ARGS[1],ARGS[2]}
elseif Call == "onInteract" then
 
elseif Call == "onKeyPress" then
 
elseif Call == "onMessage" then
 
end
for i = 2, #ARGS do
    callbacks[#callbacks][i] = string.sub(line,ARGS[i-1]+1,ARGS[i]-1)
end
end
 
local function ReadEntity(line)
local ARGS = {}
local I = 1
repeat
    if I == 1 then ARGS[I] = string.find(line,"%[") else ARGS[I] = string.find(line,"%,",ARGS[I-1]+1) end
    I = I + 1
until string.find(line,"%,",ARGS[I-1]+1) == nil
entities[#entities+1] = ARGS
end
 
function ReadScript()
local file = fs.open(arg[1],"r")
local Line
repeat
    Line = file.readLine()
    if Line ~= "==end==" then
        for i = 1, #Calls do
            if string.find(Line,Calls[i]) ~= nil then ReadCallBack(Line) end
        end
        if string.find(Line,"entity.add") ~= nil then ReadEntity(Line) end
        if string.find(Line,"funct.") ~= nil then ReadFunction(Line) end
    end
until Line == "==end=="
file.close()
end
 
function Execute()
if arg[2] == "call" then
    for i = 1, #callbacks do
        if arg[3] == callbacks[i][1] then os.queueEvent("application","load",arg[1],callbacks[i][2],callbacks[i][3],callbacks[i][4],callbacks[i][5]) if arg[3] == "onStart" then os.queueEvent("application","data",arg[1],entities) elseif arg[3] == "onInteraction" then runFunct(callbacks[i][3]) end end
    end
end
end
 
ReadScript()
Execute()
