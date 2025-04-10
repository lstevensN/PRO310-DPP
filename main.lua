if arg[2] == "debug" then
    require("lldebugger").start()
end


local timer = 0
local center = { x = 100, y = 100 }
local memory_used

function love.load()
    center.x, center.y = love.graphics.getDimensions()
    center.x = center.x / 2
    center.y = center.y / 2

    love.graphics.setBackgroundColor(1, 1, 1)

    local font = love.graphics.getFont()
    memory_used = love.graphics.newText(font, "")
end

function love.update(dt)
    timer = timer + dt

    -- Garbage Collection (every 3 seconds)
    if timer % 3 < 0.1 then
        collectgarbage("collect")
        memory_used:set('Memory usage: ' .. math.floor(collectgarbage('count')) .. ' kB')
        collectgarbage("stop")
    end
end

function love.draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, center.x * 2, 35)
    love.graphics.circle('line', center.x + math.sin( timer ) * 20, center.y + math.cos( timer ) * 20, 20)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(tostring(love.timer.getFPS( )).." FPS", 20, 10)
    love.graphics.draw(memory_used, center.x * 2 - 20 - memory_used:getWidth(), 10)
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