--!strict
local game = {}
game.raylib = require("raylib")
local utils = require("raylib-utils")

local _instance = nil

-- structure for everything
export type script = {
    onAwake: ((self: any) -> ())?,
	onUpdate: ((self: any, dt: number) -> ())?,
	onDraw: ((self: any, dt: number) -> ())?
}

local scripts : { [string]:script } = {}

function game.addScript(name: string, script: script)
    scripts[name] = script
end

function game.getScript(name: string): script?
    return scripts[name]
end

function game.run(size: utils.vec2, title: string)
    local raylib = game.raylib
    raylib.InitWindow(size, title)
    raylib.SetTargetFPS(60)
    
    for _, v in pairs(scripts) do
        if v.onAwake then
            v.onAwake(v)
        end
    end

    while not raylib.WindowShouldClose() do
        local dt: number = raylib.GetFrameTime()

        for _, v in pairs(scripts) do
            if v.onUpdate then
                v.onUpdate(v, dt)
            end
        end

        raylib.BeginDrawing()
        
        for _, v in pairs(scripts) do
            if v.onDraw then
                v.onDraw(v, dt)
            end
        end
        raylib.EndDrawing()
    end

    raylib.CloseWindow()
end

return game