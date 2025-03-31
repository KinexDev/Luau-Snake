--!strict
local game = require("game")
local utils = require("raylib-utils")

export type rendering = game.script & { 
    gridSizeX: number,
    gridSizeY: number,
    drawObject: (self: rendering, pos: utils.vec2, color: utils.color) -> ()
}

local gridColor: utils.color = utils.color.new(170, 215, 81)
local gridColor2: utils.color = utils.color.new(162, 209, 73)
local backgroundColor: utils.color = utils.color.new(87, 138, 52)
local topRect: utils.color = utils.color.new(74, 117, 44)

local function onDraw(self: rendering, dt: number)
    game.raylib.ClearBackground(backgroundColor)
    local scale: number = (game.raylib.GetScreenHeight() / 1.25) / self.gridSizeY

    game.raylib.DrawRectangle(utils.vec2.new(0, 0), utils.vec2.new(game.raylib.GetScreenWidth(), 60), topRect);
    game.raylib.DrawText("FPS: " .. game.raylib.GetFPS(), 20, utils.vec2.new(5, 5), utils.color.new(255, 255, 255))
    
    local offsetX: number = (game.raylib.GetScreenWidth() - scale * (self.gridSizeX)) / 2
    local offsetY: number = (game.raylib.GetScreenHeight() - scale * self.gridSizeY) / 2
    offsetY += 30

    for x = 0, self.gridSizeX - 1 do
        for y = 0, self.gridSizeY - 1 do
            game.raylib.DrawRectangle(
                utils.vec2.new(scale * x + offsetX, scale * y + offsetY),
                utils.vec2.new(scale, scale),
                if (x + y) % 2 == 0 then gridColor else gridColor2
            )
        end
    end
end

local function drawObject(self: rendering, pos: utils.vec2, color: utils.color)
    local scale: number = (game.raylib.GetScreenHeight() / 1.25) / self.gridSizeY
    local offsetX: number = (game.raylib.GetScreenWidth() - scale * (self.gridSizeX)) / 2
    local offsetY: number = (game.raylib.GetScreenHeight() - scale * self.gridSizeY) / 2
    offsetY += 30
    game.raylib.DrawRectangle(utils.vec2.new(scale * math.floor(pos.x) + offsetX, scale * math.floor(pos.y) + offsetY),
        utils.vec2.new(scale, scale), color)
end

local script: rendering = { onDraw = onDraw, gridSizeX = 16, gridSizeY = 15,
        drawObject = drawObject }
return script