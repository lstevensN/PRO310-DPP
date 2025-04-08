if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()

end

function love.update(dt)

end

function love.draw()

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