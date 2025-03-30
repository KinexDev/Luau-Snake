--!strict
local game = require("game")

local snake = require("snake")
local player = require("player")
local apples = require("apples")
local utils = require("raylib-utils")

game.addScript("snake", snake)
game.addScript("player", player)
game.addScript("apples", apples)

game.run(utils.vec2.new(600, 600), "rendering")