function console() shell.run("system/primary_console.sys") end

function os() shell.run("os/Desktop.os") end

parallel.waitForAny(console,os)

os.shutdown()
