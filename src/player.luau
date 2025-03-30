--!strict
local engine = require("engine")
local utils = require("raylib-utils")

export type player = engine.script & { 
    position: utils.vec2,
    moveSpeed: number
}

local function onAwake(self: player)
    print("this is ran on start!")
end

local function onUpdate(self: player, dt: number)
    if engine.raylib.IsKeyDown(utils.keys.W) then
        self.position.y -= self.moveSpeed * dt
    end

    if engine.raylib.IsKeyDown(utils.keys.S) then
        self.position.y += self.moveSpeed * dt
    end

    if engine.raylib.IsKeyDown(utils.keys.A) then
        self.position.x -= self.moveSpeed * dt
    end

    if engine.raylib.IsKeyDown(utils.keys.D) then
        self.position.x += self.moveSpeed * dt
    end
end

local function onDraw(self: player, dt: number)
    engine.raylib.DrawRectangle(self.position, utils.vec2.new(50, 50), utils.color.new(255, 0, 0))
end

local script: player = { onAwake = onAwake, onUpdate = onUpdate, 
    onDraw = onDraw, position = utils.vec2.new(0, 0), moveSpeed = 400}
return script