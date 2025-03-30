--!strict
local scripting = require("components")

export type script2 = scripting.component & { 
    name: string 
}

local function onUpdate(self: script2, dt: number)
    print("this is ran every frame!")
    print(dt)
end

local function onAwake(self: script2)
    print("this is ran on start!")
end

return { onAwake = onAwake, onUpdate = onUpdate, name = "hello world!" } :: script2