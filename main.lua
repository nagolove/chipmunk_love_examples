local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local ipairs = _tl_compat and _tl_compat.ipairs or ipairs; local math = _tl_compat and _tl_compat.math or math


require("mobdebug").start()
require("love")
local wrp = require("wrp")
local space = nil
local tank


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








local init_tank = {
   type = "tank",
   x = 300,
   y = 300,
   w = rect_body.w,
   h = rect_body.h,


   anchorA = { 0., 0. },
   anchorB = { 0., -30. },





   turret_dx = 0,
   turret_dy = 0,
   turret_rot_point = { 128., 128. },


   turret_w = rect_turret.w,
   turret_h = rect_turret.h,
}


local dx = 0
local dy = 0

local counter = 1

local function spawn()
   local self = {
      id = counter,
   }
   counter = counter + 1
   tank = wrp.tank_new(
   init_tank, self)

end

local gr = love.graphics
local dbg_color = { 0, 0.7, 0, 1 }
local dbg_dot_color = { 0.1, 0.6, 0.1 }

function DbgDrawCircle(px, py, angle, rad)
   gr.setColor(dbg_color)
   gr.circle("line", px, py, rad)

end

function DbgDrawSegment(ax, ay, bx, by)
   gr.setColor(dbg_color)
   gr.line(ax, ay, bx, by)

end

function DbgDrawFatSegment(ax, ay, bx, by, rad)
   gr.setColor(dbg_color)
   local oldw = gr.getLineWidth()
   gr.setLineWidth(rad)
   gr.line(ax, ay, bx, by)
   gr.setLineWidth(oldw)

end

function DbgDrawPolygon(polygon, rad)
   gr.setColor(dbg_color)
   gr.polygon('line', polygon)

end

function DbgDrawDot(size, px, py)
   gr.setColor(dbg_dot_color)
   gr.circle('fill', px, py, size)

end

function love.load(_)
   space = wrp.space_new(.2)
   wrp.space_set(space)
   wrp.space_debug_draw(
   DbgDrawCircle,
   DbgDrawSegment,
   DbgDrawFatSegment,
   DbgDrawPolygon,
   DbgDrawDot)

   spawn()
end

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

   local kb = love.keyboard

   local k = 4
   local impx = 10
   local px, py = 0, 0

   if kb.isDown("lshift") then
      if kb.isDown("left") then
         tank:turret_rotate(-k)
      end
      if kb.isDown("right") then
         tank:turret_rotate(k)
      end
   else
      if kb.isDown("left") then

         tank:apply_impulse(-0.2, 0, 128, 128)
      end
      if kb.isDown("right") then

         tank:apply_impulse(0.2, 0, 128, 128)
      end
   end

   if kb.isDown('up') then
      tank:apply_impulse(0, -impx, px, py)
   end
   if kb.isDown('down') then
      tank:apply_impulse(0, impx, px, py)
   end
end

local white = { 1, 1, 1, 1 }
local blue = { 0, 0, 1, 1 }

local function draw_axises()
   local w, h = gr.getDimensions()
   gr.setColor(blue)
   gr.line(dx, 0, dx, h)
   gr.line(0, dy, w, dy)
end

local function print_desctiption()
   local x, y = 0., 0.
   gr.print('chipmunk test stend', x, y)
   y = y + gr.getFont():getHeight()

end

function love.draw()



   wrp.query_all_tanks_t(function(
      x, y, angle, obj,
      tur_x, tur_y, tur_angle,
      debug_verts)

      gr.setColor({ 1, 0, 0, 1 })
      if debug_verts then
         for _, verts in ipairs(debug_verts) do

            local i = 1
            while i < #verts do


               verts[i] = verts[i] + x + dx
               verts[i + 1] = verts[i + 1] + y + dy
               i = i + 2
            end

            gr.setLineWidth(1)
            gr.polygon('line', verts)
         end
      end

      gr.setColor(white)



      gr.push()
      gr.translate(x, y)
      gr.rotate(angle)
      gr.translate(-rect_body.w / 2, -rect_body.h / 2)

      gr.draw(tex_body, quad_body, 0, 0)
      gr.pop()



      gr.push()
      gr.translate(x, y)
      gr.rotate(tur_angle + math.pi)
      gr.translate(
      -rect_turret.w / 2,
      -rect_turret.h / 2 + init_tank.anchorB[2])

      gr.draw(tex_turret, quad_turret, 0, 0)
      gr.pop()
   end)

   wrp.space_debug_draw(
   DbgDrawCircle,
   DbgDrawSegment,
   DbgDrawFatSegment,
   DbgDrawPolygon,
   DbgDrawDot)


   draw_axises()
   print_desctiption()
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
   if key == 'escape' then
      love.event.quit()
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
