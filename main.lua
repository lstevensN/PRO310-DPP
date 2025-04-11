if arg[2] == "debug" then
    require("lldebugger").start()
end


local timer = 0
local center = { x = 100, y = 100 }
local memory_used

Debug = require("src.debug")

function love.load()
    center.x, center.y = love.graphics.getDimensions()
    center.x = center.x / 2
    center.y = center.y / 2

    love.graphics.setBackgroundColor(1, 1, 1)

    Debug.load()
    require("src.input")
end

function love.update(dt)
    timer = timer + dt
    Debug.update(dt)

    -- Garbage Collection (every 3 seconds)
    if timer % 3 < 0.1 then
        collectgarbage("collect")
        collectgarbage("stop")
    end
end

function love.draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle('line', center.x + math.sin( timer ) * 20, center.y + math.cos( timer ) * 20, 20)

    if Debug.shown then Debug.draw(center.x * 2) end
end


local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
---@diagnostic disable-next-line: undefined-global
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end