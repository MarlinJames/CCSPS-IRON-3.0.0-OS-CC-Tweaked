local arg = {...}

local website = http.get(arg[1])
local github_file
if website then
    github_file = website.readAll()
    website.close()
end

local file = fs.open(arg[2],"w")
file.write(github_file)
file.close()
