local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local ipairs = _tl_compat and _tl_compat.ipairs or ipairs


require("love")
local wrp = require("wrp")
local space = nil
local tank

local init_tank = {
   type = "tank",
   x = 100,
   y = 100,
   w = 200,
   h = 200,
   turret_dx = 0,
   turret_dy = 0,
   turret_w = 100,
   turret_h = 100,
}

local rect_body = {
   x = 87,
   y = 73,
   w = 82,
   h = 110,
}

local rect_turret = {
   x = 101,
   y = 0,
   w = 54,
   h = 160,
}


local dx = 100
local dy = 100

function love.load(_)
   space = wrp.space_new(.2)
   wrp.space_set(space)

   tank = wrp.tank_new(
   init_tank, {})

end

local gr = love.graphics
local tex_body = gr.newImage("body.png")
local tex_turret = gr.newImage("turret.png")




local quad_body = gr.newQuad(
rect_body.x,
rect_body.y,
rect_body.w,
rect_body.h,
tex_body)


local quad_turret = gr.newQuad(
rect_turret.x,
rect_turret.y,
rect_turret.w,
rect_turret.h,
tex_turret)



function love.update(dt)
   wrp.space_step(dt)
end

local white = { 1, 1, 1, 1 }
local blue = { 0, 0, 1, 1 }

local function draw_axises()
   local w, h = gr.getDimensions()
   gr.setColor(blue)
   gr.line(dx, 0, dx, h)
   gr.line(0, dy, w, dy)
end

function love.draw()



   wrp.query_all_tanks_t(function(
      x, y, angle, obj,
      tur_x, tur_y, tur_angle,
      debug_verts)

      gr.setColor({ 1, 0, 0, 1 })
      for _, verts in ipairs(debug_verts) do

         local i = 1
         while i < #verts do

            verts[i] = verts[i] + x + dx
            verts[i + 1] = verts[i + 1] + y + dy
            i = i + 2
         end

         gr.polygon('line', verts)
      end

      gr.setColor(white)
      gr.draw(tex_body, quad_body, x, y)
      gr.draw(tex_turret, quad_turret, x, y)

   end)

   draw_axises()
end

function love.resize(_, _)
end

function love.quit()
end

function love.textinput(_)
end

function love.keyreleased(_, _)
end

function love.keypressed(_, key)
   if key == "left" then
      tank:apply_impulse(0, 0.1, 0, 0)
   end
   if key == "right" then
      tank:apply_impulse(0, -0.1, 0, 0)
   end
end

function love.mousemoved(_, _, _, _)
end

function love.mousepressed(_, _, _)
end

function love.mousereleased(_, _, _)
end

function love.wheelmoved(_, _)
end
