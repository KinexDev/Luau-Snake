--!strict
local game = require("game")
local utils = require("raylib-utils")
local rendering = require("rendering")

local renderingInstance: rendering.rendering = nil

local playerColor: utils.color = utils.color.new(90, 127, 255)
local previousPositions: { utils.vec2 } = {}
local previousPosition: utils.vec2 = utils.vec2.zero
local previousDirection: utils.vec2 = utils.vec2.zero
local direction: utils.vec2 = utils.vec2.zero
local playerPosition: utils.vec2 = utils.vec2.new(5, 6)

local applePosition: utils.vec2 = utils.vec2.new(10, 6)
local appleColor: utils.color = utils.color.new(255, 59, 48)

local function onAwake(self)
    previousPosition = playerPosition

    for i = 0, 2 do
        table.insert(previousPositions, utils.vec2.new(previousPosition.x - i, previousPosition.y))
    end

    renderingInstance = game.getScript("rendering") :: rendering.rendering
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

local function onUpdate(self, dt: number)
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
            playerPosition += direction

            if checkForCollisions(playerPosition) then
                previousPositions = {}
                previousPosition = utils.vec2.zero
                previousDirection = utils.vec2.zero
                direction = utils.vec2.zero
                playerPosition = utils.vec2.new(5, 6)
                applePosition = utils.vec2.new(10, 6)
                
                onAwake(self)  
            end
        end

        if playerPosition ~= previousPosition then   
            table.insert(previousPositions, 1, playerPosition)
            table.remove(previousPositions, #previousPositions)
        end

        if playerPosition.x == applePosition.x and playerPosition.y == applePosition.y then
            local randomPosition: utils.vec2 = utils.vec2.new(math.random(renderingInstance.gridSizeX - 1), math.random(renderingInstance.gridSizeY - 1))

            while checkForCollisions(randomPosition) do
                randomPosition = utils.vec2.new(math.random(renderingInstance.gridSizeX - 1), math.random(renderingInstance.gridSizeY - 1))
            end
            
            applePosition = randomPosition
            table.insert(previousPositions, 1, playerPosition)
        end

        ticks = 0
    end
end

local function onDraw(self, dt: number)
    for _, v in pairs(previousPositions) do
        renderingInstance:drawObject(v, playerColor)
    end

    renderingInstance:drawObject(applePosition, appleColor)
end

local script: game.script = { onAwake = onAwake, onUpdate = onUpdate, 
    onDraw = onDraw }
return script