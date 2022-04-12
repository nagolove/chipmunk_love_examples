-- vim: set colorcolumn=85
-- vim: fdm=marker

require "love"
local wrp = require "wrp"
local space: wrp.Space = nil
local tank: wrp.Tank

function love.load(_: {string})
    space = wrp.space_new(.2)
    wrp.space_set(space)

    tank = wrp.tank_new(
        {
            type = "tank",
            x = 100,
            y = 100,
            w = 200,
            h = 200,
            turret_dx = 0,
            turret_dy = 0,
            turret_w = 100,
            turret_h = 100,
        }, 
        {}
    )
end

local tex_body = love.graphics.newImage("body.png")
local tex_turret = love.graphics.newImage("turrert.png")
local gr = love.graphics

function love.update(dt: number)
    wrp.space_step(dt)
    wrp.query_all_tanks_t(function(
        x: number, y: number, angle: number, obj: any,
        tur_x: number, tur_y: number, tur_angle: number,
        debug_verts: {{number}} 
    )

    end)
end

function love.draw()
    gr.setColor{1, 0.05, 0}
    gr.rectangle("fill", 0, 0, 400, 400)
end

function love.resize(_: integer, _: integer)
end

function love.quit(): boolean
end

function love.textinput(_: string)
end

function love.keyreleased(_: love.keyboard.KeyConstant, _: love.keyboard.Scancode)
end

function love.keypressed(_: string, _: string)
end

function love.mousemoved(_: number, _: number, _: number, _: number)
end

function love.mousepressed(_: number, _: number, _: number)
end

function love.mousereleased(_: number, _: number, _: number)
end

function love.wheelmoved(_: number, _: number)
end

