-- vim: set colorcolumn=85
-- vim: fdm=marker

require("mobdebug").start()
require "love"
local wrp = require "wrp"
local space: wrp.Space = nil
local tank: wrp.Tank

-- Кусок вырезаемый из текстуры
local rect_body = {
    x = 87,
    y = 73,
    w = 82,
    h = 110,
    --w = 82,
    --h = 82,
}

-- Кусок вырезаемый из текстуры
local rect_turret = {
    x = 101,
    y = 0,
    w = 54,
    h = 160,
    --w = 82,
    --h = 82,
}

--local rect_turret = {
    --x = 101,
    --y = 0,
    --w = 54,
    --h = 40,
--}

local init_tank = {
    type = "tank",
    x = 300,
    y = 300,
    w = rect_body.w,
    h = rect_body.h,

    -- Точки сочленения тел
    anchorA = { 0., 0. },
    anchorB = { 0., -30. },
    --anchorB = { 0., 0. },

    -- Смещение координат турели
    --turret_dx = -140,
    --turret_dy = -80,
    turret_dx = 0,
    turret_dy = 0,
    --turret_rot_point = { 127., 128. },
    turret_rot_point = { rect_turret.w / 2., rect_turret.h / 2.},

    -- Размеры турели
    turret_w = rect_turret.w,
    turret_h = rect_turret.h,
} 

-- Дополнительное смещение осей координат.
local dx = 0
local dy = 0

local counter = 1

local function spawn()
    local self = {
        id = counter,
    }
    counter = counter + 1
    tank = wrp.tank_new(
        init_tank, self as table
    )
end

local gr = love.graphics
local dbg_color = {0, 0.7, 0, 1}
local dbg_dot_color = {0.1, 0.6, 0.1}

function DbgDrawCircle(px: number, py: number, angle: number, rad: number)
    gr.setColor(dbg_color)
    gr.circle("line", px, py, rad)
    --print("circle")
end

function DbgDrawSegment(ax: number, ay: number, bx: number, by: number)
    gr.setColor(dbg_color)
    gr.line(ax, ay, bx, by)
    --print("segment")
end

function DbgDrawFatSegment(ax: number, ay: number, bx: number, by: number, rad: number)
    gr.setColor(dbg_color)
    local oldw = gr.getLineWidth()
    gr.setLineWidth(rad)
    gr.line(ax, ay, bx, by)
    gr.setLineWidth(oldw)
    --print("fatsegment")
end

function DbgDrawPolygon(polygon: {number}, rad: number)
    gr.setColor(dbg_color)
    gr.polygon('line', polygon)
    --print("polygon")
end

function DbgDrawDot(size: number, px: number, py: number)
    gr.setColor(dbg_dot_color)
    gr.circle('fill', px, py, size)
    --print("dot")
end

function love.load(_: {string})
    space = wrp.space_new(.09)
    wrp.space_set(space)
    wrp.space_debug_draw(
        DbgDrawCircle,
        DbgDrawSegment,
        DbgDrawFatSegment,
        DbgDrawPolygon,
        DbgDrawDot
    )
    spawn()
end

local tex_body = gr.newImage("body.png") as gr.Texture
local tex_turret = gr.newImage("turret.png") as gr.Texture

--local quad_body = gr.newQuad(0, 0, 256, 256, tex_body)
--local quad_turret = gr.newQuad(0, 0, 256, 256, tex_turret)

local quad_body = gr.newQuad(
    rect_body.x, 
    rect_body.y,
    rect_body.w,
    rect_body.h,
    tex_body
)

local quad_turret = gr.newQuad(
    rect_turret.x,
    rect_turret.y,
    rect_turret.w,
    rect_turret.h,
    tex_turret
)
--local quad_turret = gr.newQuad(0, 0, 256, 256, tex_turret)

--[[
local enum ContolState 
    "movement"
    "rotation"
    "turret_rotation"
end
--]]

global ctl_movement = false
global ctl_rotatioin = false
global ctl_tur_rotation = false

function love.update(dt: number)
    wrp.space_step(dt)

    local kb = love.keyboard

    local k = 4
    local impx = 10
    local px, py = 0, 0

    ctl_rotatioin = false
    ctl_tur_rotation = false
    ctl_movement = false

    if kb.isDown("lshift") then
        if kb.isDown("left") then
            tank:turret_rotate(-k)
            ctl_tur_rotation = true
        end
        if kb.isDown("right") then
            tank:turret_rotate(k)
            ctl_tur_rotation = true
        end
    else
        if kb.isDown("left") then
            --tank:apply_impulse(0, 0.1, 0, 0)
            tank:apply_impulse(-0.2, 0, 128, 128)
            ctl_rotatioin = true
        end
        if kb.isDown("right") then
            --tank:apply_impulse(0, -0.1, 0, 0)
            tank:apply_impulse(0.2, 0, 128, 128)
            ctl_rotatioin = true
        end
    end

    if kb.isDown('up') then
        tank:apply_impulse(0, -impx, px, py)
        ctl_movement = true
    end
    if kb.isDown('down') then
        tank:apply_impulse(0, impx, px, py)
        ctl_movement = true
    end
end

local white = {1, 1, 1, 1}
local blue = {0, 0, 1, 1}

local function draw_axises()
    local w, h = gr.getDimensions()
    gr.setColor(blue)
    gr.line(dx, 0, dx, h)
    gr.line(0, dy, w, dy)
end

local font = gr.newFont(32)
local desc_text = gr.newText(font)
local text_pressed = {0, 1, 0, 1}
local text_unpressed = {1, 1, 1, 1}
local desc_table = {
    {
        {1, 1, 1, 1},
        'up|down: ',
        {1, 0, 1, 1},
        'tank movement',
        flag = 'ctl_movement',
    },
    {
        {1, 1, 1, 1},
        'left|right: ',
        {1, 0, 1, 1},
        'tank rotation',
        flag = 'ctl_rotatioin',
    },
    {
        {1, 1, 1, 1},
        'shift + left|right: ',
        {1, 0, 1, 1},
        'turret rotation',
        flag = 'ctl_tur_rotation',
    },
}

local function desc_table_set_colors()
    --print(_G['ctl_movement'])
    --[[
    for k, v in ipairs(desc_table) do
        for sk, sv in ipairs(v as {string}) do
            local sv_: any = sv as any
            if type(sv_) == 'string' then
                if string.find(sv_ as string, 'tank movement') then
                    print(k, v, sk, sv)
                else
                    print('none')
                end
            end
        end
    end
    --]]
    for k, v in ipairs(desc_table) do
        --local tmp = (v as {any:any})['flag'] as string
        --[[
        if (v as {any:any})['flag'] and _G[tmp] then
            v[1] = text_pressed
        else
            v[1] = text_unpressed
        end
        --]]
    end
end

local function print_desctiption()
    local x, y = 0., 0.
    gr.setFont(font)
    gr.setColor {1, 1, 1, 1}

--[[ {{{
    gr.print('chipmunk test stend', x, y)
    y = y + gr.getFont():getHeight()

    gr.print('up|down: tank movement', x, y)
    y = y + gr.getFont():getHeight()

    gr.print('left|right: tank rotation', x, y)
    y = y + gr.getFont():getHeight()

    gr.print('shift + left|right: turret rotation', x, y)
    y = y + gr.getFont():getHeight()
--]] -- }}}

    desc_table_set_colors()
    for _, v in ipairs(desc_table) do
        desc_text:add(v as {string}, x, y)
        y = y + gr.getFont():getHeight()
    end
    gr.draw(desc_text as gr.Drawable)
    desc_text:clear()

end

function love.draw()
    --gr.setColor{1, 0.05, 0}
    --gr.rectangle("fill", 0, 0, 400, 400)

    wrp.query_all_tanks_t(function(
        x: number, y: number, angle: number, obj: any,
        tur_x: number, tur_y: number, tur_angle: number,
        debug_verts: {{number}}
    )
        gr.setColor{1, 0, 0, 1}
        if debug_verts then
            for _, verts in ipairs(debug_verts) do

                local i = 1
                while i < #verts do
                    --verts[i] = verts[i] + x + dx
                    --verts[i + 1] = verts[i + 1] + y + dy
                    verts[i] = verts[i] + x + dx
                    verts[i + 1] = verts[i + 1] + y + dy
                    i = i + 2
                end

                gr.setLineWidth(1)
                gr.polygon('line', verts)
            end
        end

        gr.setColor(white)

        --x = x - rect_body.w / 2
        --y = y - rect_body.h / 2
        gr.push()
        gr.translate(x, y)
        gr.rotate(angle)
        gr.translate(-rect_body.w / 2, -rect_body.h / 2)
        --gr.draw(tex_body, quad_body, x, y, angle)
        gr.draw(tex_body, quad_body, 0, 0)
        gr.pop()

        --tur_x = tur_x - rect_turret.w / 2
        --tur_y = tur_y - rect_turret.h / 2
        gr.push()
        gr.translate(x, y)
        gr.rotate(tur_angle + math.pi)
        gr.translate(
            -rect_turret.w / 2,
            -rect_turret.h / 2 + init_tank.anchorB[2]
        )
        gr.draw(tex_turret, quad_turret, 0, 0)
        gr.pop()
    end)

    wrp.space_debug_draw(
        DbgDrawCircle,
        DbgDrawSegment,
        DbgDrawFatSegment,
        DbgDrawPolygon,
        DbgDrawDot
    )

    draw_axises()
    print_desctiption()
end

function love.resize(_: integer, _: integer)
end

function love.quit(): boolean
end

function love.textinput(_: string)
end

function love.keyreleased(_: love.keyboard.KeyConstant, _: love.keyboard.Scancode)
end

function love.keypressed(_: string, key: string)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousemoved(_: number, _: number, _: number, _: number)
end

function love.mousepressed(_: number, _: number, _: number)
end

function love.mousereleased(_: number, _: number, _: number)
end

function love.wheelmoved(_: number, _: number)
end

