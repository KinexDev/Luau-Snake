--!strict
local game = {}
game.raylib = require("raylib")
local utils = require("raylib-utils")
game.gameRunning = true;

local _instance = nil

-- structure for everything
export type script = {
    onAwake: ((self: any) -> ())?,
    onLoad: ((self: any) -> ())?,
    onClose: ((self: any) -> ())?,
	onUpdate: ((self: any, dt: number) -> ())?,
	onDraw: ((self: any, dt: number) -> ())?
}

local scripts: { [string]:script } = {}
local index: { [number]:string } = {}

function game.addScript(name: string, script: script)
    table.insert(index, name)
    scripts[name] = script
end

function game.getScript(name: string): script?
    return scripts[name]
end

function game.run(size: utils.vec2, title: string)
    local raylib = game.raylib
    raylib.InitWindow(size, title)
    raylib.SetTargetFPS(60)
    raylib.InitAudioDevice()
    
    for _, v in pairs(scripts) do
        if v.onAwake then
            v.onAwake(v)
        end
    end

    for _, v in pairs(scripts) do
        if v.onLoad then
            v.onLoad(v)
        end
    end

    while not raylib.WindowShouldClose() and game.gameRunning do
        local dt: number = raylib.GetFrameTime()

        for k, v in ipairs(index) do
            local script: script = scripts[v]
            if script.onUpdate then
                script.onUpdate(script, dt)
            end
        end

        raylib.BeginDrawing()
        
        for k, v in ipairs(index) do
            local script: script = scripts[v]
            if script.onDraw then
                script.onDraw(script, dt)
            end
        end
        raylib.EndDrawing()
    end

    for _, v in pairs(scripts) do
        if v.onClose then
            v.onClose(v)
        end
    end

    raylib.CloseAudioDevice()
    raylib.CloseWindow()
end

return game