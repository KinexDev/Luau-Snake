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

local points: number = 0

local eat: utils.sound = nil
local move: utils.sound = nil
local dead: utils.sound = nil

local isDead: boolean = false

local function onAwake(self)
    points = 0
    previousPositions = {}
    previousPosition = utils.vec2.zero
    previousDirection = utils.vec2.zero
    direction = utils.vec2.zero
    playerPosition = utils.vec2.new(5, 6)
    applePosition = utils.vec2.new(10, 6)

    previousPosition = playerPosition

    for i = 0, 2 do
        table.insert(previousPositions, utils.vec2.new(previousPosition.x - i, previousPosition.y))
    end

    renderingInstance = game.getScript("rendering") :: rendering.rendering
end

local function onLoad(self)
    eat = game.raylib.LoadSound("res/apple.wav")
    move = game.raylib.LoadSound("res/move.wav")
    dead = game.raylib.LoadSound("res/dead.wav")

    game.raylib.SetSoundVolume(move, 0.2)
end

local function onClose(self)
    game.raylib.UnloadSound(eat)
    game.raylib.UnloadSound(move)
    game.raylib.UnloadSound(dead)
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

local alreadyChanged: boolean = false
local ticks: number = 0

local function onUpdate(self, dt: number)
    if isDead then
        if game.raylib.IsKeyPressed(utils.keys.R) then
            isDead = false
            onAwake(self)
        end
        return
    end
    if game.raylib.IsKeyPressed(utils.keys.W) and not alreadyChanged then
        if previousDirection.y == 0 then
            direction = utils.vec2.down
            alreadyChanged = true
            
            game.raylib.SetSoundPitch(move, 1.15)
            game.raylib.PlaySound(move)
        end
    end

    if game.raylib.IsKeyPressed(utils.keys.S) and not alreadyChanged then
        if previousDirection.y == 0 then
            direction = utils.vec2.up
            alreadyChanged = true
            
            game.raylib.SetSoundPitch(move, 0.75)
            game.raylib.PlaySound(move)
        end
    end

    if game.raylib.IsKeyPressed(utils.keys.A) and not alreadyChanged then
        if previousDirection.x == 0 and direction ~= utils.vec2.zero then
            direction = utils.vec2.left
            alreadyChanged = true
            
            game.raylib.SetSoundPitch(move, 1.25)
            game.raylib.PlaySound(move)
        end
    end

    if game.raylib.IsKeyPressed(utils.keys.D) and not alreadyChanged then
        if previousDirection.x == 0 then
            direction = utils.vec2.right
            alreadyChanged = true

            game.raylib.SetSoundPitch(move, 0.95)
            game.raylib.PlaySound(move)
        end
    end
    
    ticks += dt

    if ticks > 0.16 then
        alreadyChanged = false
        if direction ~= utils.vec2.zero then
            previousDirection = direction

            if checkForCollisions(playerPosition + direction) then
                game.raylib.PlaySound(dead)
                isDead = true
                return
            end
            
            playerPosition += direction
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

            game.raylib.PlaySound(eat)
            points += 1
            applePosition = randomPosition

            table.insert(previousPositions, previousPositions[#previousPositions])
        end

        ticks = 0
    end
end

local function onDraw(self, dt: number)
    for _, v in pairs(previousPositions) do
        renderingInstance:drawObject(v, playerColor)
    end

    renderingInstance:drawObject(applePosition, appleColor)

    game.raylib.DrawText(tostring(points), 30, utils.vec2.new(300, 20), utils.color.new(255, 255, 255))
    
    if isDead then
        game.raylib.DrawText("Press R to restart!", 40, utils.vec2.new(100, 300), utils.color.new(255, 255, 255))
    end
end

local script: game.script = { onAwake = onAwake, onUpdate = onUpdate, 
    onDraw = onDraw, onLoad = onLoad, onClose = onClose }
return script