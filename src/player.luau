--!strict
local game = require("game")
local utils = require("raylib-utils")
local apple = require("apples")
local rendering = require("rendering")

export type player = game.script & { 
    position: utils.vec2,
    moveSpeed: number
}

local renderingInstance: rendering.rendering = nil
local playerColor: utils.color = utils.color.new(90, 127, 255) 
local step: thread = nil
local previousPositions: { utils.vec2 } = {}
local previousPosition: utils.vec2 = utils.vec2.zero
local previousDirection: utils.vec2 = utils.vec2.zero
local direction: utils.vec2 = utils.vec2.zero
local appleInstance: apple.apples = nil

local function onAwake(self: player)
    previousPosition = self.position

    for i = 0, 2 do
        table.insert(previousPositions, utils.vec2.new(previousPosition.x - i, previousPosition.y))
    end

    renderingInstance = game.getScript("rendering") :: rendering.rendering
    appleInstance = game.getScript("apples") :: apple.apples
end

local function checkForCollisions(position: utils.vec2)
    for _, v in pairs(previousPositions) do
        if v.x == position.x and v.y == position.y then
            return true
        end
    end

    if position.x < 0 or position.y < 0 or position.x > renderingInstance.gridSizeX - 1 or position.y > renderingInstance.gridSizeY - 1 then
        return true
    end

    return false
end

local ticks: number = 0

local function onUpdate(self: player, dt: number)
    if game.raylib.IsKeyPressed(utils.keys.W) then
        if previousDirection.y == 0 then
            direction = utils.vec2.down
        end
    end

    if game.raylib.IsKeyPressed(utils.keys.S) then
        if previousDirection.y == 0 then
            direction = utils.vec2.up
        end
    end

    if game.raylib.IsKeyPressed(utils.keys.A) then
        if previousDirection.x == 0 and direction ~= utils.vec2.zero then
            direction = utils.vec2.left
        end
    end

    if game.raylib.IsKeyPressed(utils.keys.D) then
        if previousDirection.x == 0 then
            direction = utils.vec2.right
        end
    end
    
    ticks += dt

    if ticks > 0.16 then
        if direction ~= utils.vec2.zero then
            previousDirection = direction
            self.position += direction

            if checkForCollisions(self.position) then
                game.gameRunning = false    
            end
        end

        if self.position ~= previousPosition then   
            table.insert(previousPositions, 1, self.position)
            table.remove(previousPositions, #previousPositions)
        end

        print(self.position)
        print(appleInstance.position)

        if self.position.x == appleInstance.position.x and self.position.y == appleInstance.position.y then
            local randomPosition: utils.vec2 = utils.vec2.new(math.random(renderingInstance.gridSizeX - 1), math.random(renderingInstance.gridSizeY - 1))

            while checkForCollisions(randomPosition) do
                randomPosition = utils.vec2.new(math.random(renderingInstance.gridSizeX - 1), math.random(renderingInstance.gridSizeY - 1))
            end
            
            appleInstance.position = randomPosition
            table.insert(previousPositions, 1, self.position)
        end

        ticks = 0
    end
end

local function onDraw(self: player, dt: number)
    for _, v in pairs(previousPositions) do
        renderingInstance:drawObject(v, playerColor)
    end
end

local script: player = { onAwake = onAwake, onUpdate = onUpdate, 
    onDraw = onDraw, position = utils.vec2.new(5, 6), moveSpeed = 10}
return script