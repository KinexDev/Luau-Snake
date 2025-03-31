--!strict
local game = require("game")

local rendering = require("rendering")
local player = require("player")
local utils = require("raylib-utils")

game.addScript("rendering", rendering)
game.addScript("player", player)

game.run(utils.vec2.new(600, 600), "snake")