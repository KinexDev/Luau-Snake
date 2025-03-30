--!strict
local game = require("game")
local utils = require("raylib-utils")
local apple = require("apples")
local snake = require("snake")

export type player = game.script & { 
    position: utils.vec2,
    moveSpeed: number
}

local snakeInstance: snake.snake = nil
local appleInstance: apple.apples = nil
local playerColor: utils.color = utils.color.new(90, 127, 255) 

local function onAwake(self: player)
    snakeInstance = game.getScript("snake") :: snake.snake
    appleInstance = game.getScript("apples") :: apple.apples
end

local function onUpdate(self: player, dt: number)
    if game.raylib.IsKeyDown(utils.keys.W) then
        self.position.y -= self.moveSpeed * dt
    end

    if game.raylib.IsKeyDown(utils.keys.S) then
        self.position.y += self.moveSpeed * dt
    end

    if game.raylib.IsKeyDown(utils.keys.A) then
        self.position.x -= self.moveSpeed * dt
    end

    if game.raylib.IsKeyDown(utils.keys.D) then
        self.position.x += self.moveSpeed * dt
    end
end

local function onDraw(self: player, dt: number)
    snakeInstance:drawObject(self.position, playerColor)
end

local script: player = { onAwake = onAwake, onUpdate = onUpdate, 
    onDraw = onDraw, position = utils.vec2.new(5, 5), moveSpeed = 10}
return script