
local record Wrapper
    record Shape end
    record Space end
    --record Body end

    type DbgDrawCircle = function(
        px: number, py: number, angle: number, rad: number
    )
    type DbgDrawSegment = function(
        ax: number, ay: number, bx: number, by: number
    )
    type DbgDrawFatSegment = function(
        ax: number, ay: number, bx: number, by: number,
        rad: number
    )
    type DbgDrawPolygon = function(polygon: {number}, rad: number)
    type DbgDrawDot = function(size: number, px: number, py: number)

    space_new: function(damping: number): Space
    space_free: function(Space)
    space_set: function(Space)
    space_step: function(dt: number)
    space_debug_draw: function(
        DbgDrawCircle, 
        DbgDrawSegment, 
        DbgDrawFatSegment,
        DbgDrawPolygon,
        DbgDrawDot
    )

    type EachSegmentCallback = function(x1: number, y1: number, x2: number, y2: number)
    type EachBodyCallback = function(x: number, y: number, angle: number, obj: any)

    -- Как лучше вызывать рисовку башни?
    type EachTankCallback = function(
        x: number, y: number, angle: number, obj: any,
        tur_x: number, tur_y: number, tur_angle: number,
        -- Тут лежат все вершины по телам. Если отладка выключена в wrapper, то
        -- nil
        debug_verts: {{number}} 
    )

    record FilterData
        categories: integer
        mask: integer
        group: integer
    end

    enum ObjectType
        "tank"
    end

    --query_all_shapes: function(EachBodyCallback)
    -- Работает без башни
    query_all_tanks: function(EachBodyCallback)
    -- Работает с башней. Предпочтительный вариант.
    query_all_tanks_t: function(EachTankCallback)

    record TankInit
        -- {{{
        type: ObjectType
        x: number
        y: number
        w: number
        h: number
        turret_w: number
        turret_h: number
        turret_dx: number
        turret_dy: number
        -- }}}
    end

    -- Создать поли-тело данной ширины и высоты, прикрепив к нему таблицу.
    -- Нужно указывать тип тела из перечисление ObjectType для соблюдений 
    -- внутренней логики работы модуля wrapper
    tank_new: function(
        --type: ObjectType, 
        --xpos: number, ypos: number,
        --w: number, h: number, 
        init: TankInit,
        self: table
    ): Tank, {{number}} -- второй параметр - вершины фигур. Может быть nil

    record Body
        set_position: function(b: Body, x: number, y: number)
        -- Получить положение тела и его угол поворота
        get_position: function(b: Body): number, number, number
        -- Приложить импульс к данному телу в определенной точке
        apply_impulse: function(b: Body, ix: number, iy: number, px: number, py: number)
        -- Приложить силу к данному телу в определенной точке
        apply_force: function(b: Body, fx: number, fy: number, px: number, py: number)
        -- Установить вращение тела
        set_torque: function(Body, torque: number)
        -- Узнать тип тела - динамический(1), кинематический(2) или статический(3)
        get_type: function(Body): integer
        -- Получить скорость тела
        get_vel: function(Body): number, number
        -- Получить угловую скорость тела
        get_ang_vel: function(Body): number
        -- Установить угловую скорость тела
        set_ang_vel: function(Body, w: number)
    end
    --]]

    record Tank
        turret_rotate: function(b: Tank, k: number)

        -- Получить положение тела башни и угол ее поворота.
        get_turret_position: function(b: Tank): number, number, number
        -- Установить положение корпуса
        set_position: function(b: Tank, x: number, y: number)
        -- Получить положение тела и его угол поворота
        get_position: function(b: Tank): number, number, number
        -- Приложить импульс к данному телу в определенной точке
        apply_impulse: function(b: Tank, ix: number, iy: number, px: number, py: number)
        -- Приложить силу к данному телу в определенной точке
        apply_force: function(b: Tank, fx: number, fy: number, px: number, py: number)
        -- Установить вращение тела
        set_torque: function(Tank, torque: number)
        -- Узнать тип тела - динамический(1), кинематический(2) или статический(3)
        get_type: function(Tank): integer
        -- Получить скорость тела
        get_vel: function(Tank): number, number
        -- Получить угловую скорость тела
        get_ang_vel: function(Tank): number
        -- Установить угловую скорость тела
        set_ang_vel: function(Tank, w: number)

        -- Возвращает данные о физическом теле.
        -- Масса, момент инерции, центр гравитации(x, y), положение(x, y), 
        -- скорость(x, y), сила под действием которой находится тело(x, y), 
        -- угол, угловая скорость, крутящий момент.
        get_body_stat: function(Tank): number, number, number, number, 
                                        number, number, number, number, 
                                        number, number, number, number, 
                                        number
        get_turret_stat: function(Tank): number, number, number, number, 
                                        number, number, number, number, 
                                        number, number, number, number, 
                                        number
    end

    -- Создать новый сегмент. Сегмент тонкий(не имеет толщины) и крепится к
    -- статичному телу пространства
    --new_static_segment: function(x1: number, y1: number, x2: number, y2: number): Shape
    static_segment_new: function(x1: number, y1: number, x2: number, y2: number)
    -- Удаляет и освобождает память о фигуре
    --free_static_segment: function(Shape)
    -- Вызвать функцию для рисования всех сегментов.
    static_segments_draw: function(EachSegmentCallback)

    --[[
    Какой тип должен быть у object? Body как базовый класс объектов.
    --]]
    type EachTank = function(
        object: Tank, 
        px: number, 
        py: number, 
        distance: number,
        gradx: number,
        grady: number)

    -- Обратный вызов функции для фигур в данной точке
    get_body_under_point: function(x: number, y: number, cb: EachTank)

    -- Возвращает тело данной фигуры
    --get_shape_body: function(Shape): Body

    shape_print_filter: function(Shape)
end

return Wrapper
