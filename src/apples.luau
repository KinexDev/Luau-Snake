--!strict
local game = require("game")
local utils = require("raylib-utils")
local snake = require("snake")

export type apples = game.script & { 
    position: utils.vec2,
    onEaten: (self: apples) -> ()
}

local appleColor: utils.color = utils.color.new(255, 59, 48)
local renderingInstance: snake.snake = nil

local function onAwake(self: apples)
    renderingInstance = game.getScript("snake") :: snake.snake
end

local function onEaten(self: apples)
    self.position = utils.vec2.new(math.random(renderingInstance.gridSizeX), math.random(renderingInstance.gridSizeY))
end

local function onDraw(self: apples, dt: number)
    --renderingInstance:drawObject(self.position, appleColor)
end

local script: apples = { onAwake = onAwake, onDraw = onDraw, position = utils.vec2.new(10, 6), onEaten = onEaten }
return script