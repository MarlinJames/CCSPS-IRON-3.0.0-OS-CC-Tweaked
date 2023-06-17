function console() shell.run("system/console.sys") end

function os() shell.run("os/Desktop.os") end

parallel.waitForAny(console,os)

os.shutdown()
