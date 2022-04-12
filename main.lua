


require("love")
local wrp = require("wrp")
local space = nil
local tank

function love.load(_)
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
   {})

end

local tex_body = love.graphics.newImage("body.png")
local tex_turret = love.graphics.newImage("turrert.png")
local gr = love.graphics

function love.update(dt)
   wrp.space_step(dt)
   wrp.query_all_tanks_t(function(
      x, y, angle, obj,
      tur_x, tur_y, tur_angle,
      debug_verts)


   end)
end

function love.draw()
   gr.setColor({ 1, 0.05, 0 })
   gr.rectangle("fill", 0, 0, 400, 400)
end

function love.resize(_, _)
end

function love.quit()
end

function love.textinput(_)
end

function love.keyreleased(_, _)
end

function love.keypressed(_, _)
end

function love.mousemoved(_, _, _, _)
end

function love.mousepressed(_, _, _)
end

function love.mousereleased(_, _, _)
end

function love.wheelmoved(_, _)
end
