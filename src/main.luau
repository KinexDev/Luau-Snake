--!strict
local game = require("game")

local rendering = require("rendering")
local player = require("player")
local utils = require("raylib-utils")

game.addScript("rendering", rendering.new(16, 15))
game.addScript("player", player.new())

game.run(utils.vec2.new(600, 600), "snake")