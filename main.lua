if arg[2] == "debug" then
    require("lldebugger").start()
end


local timer = 0
local width, height

local testHitbox

function love.load()
    width, height = love.graphics.getDimensions()

    love.graphics.setBackgroundColor(1, 1, 1)

    Debug = require("src.debug")
    Hitbox = require("src.hitbox")

    Debug.load()
    require("src.input")

    testHitbox = Hitbox:new( width/2, height/2, 50, 100 )
end

function love.update(dt)
    timer = timer + dt
    Debug.update(dt)

    -- Garbage Collection (every 3 seconds)
    if timer % 3 < 0.1 then collectgarbage("collect") end
end

function love.draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle('line', width * 0.5 + math.sin( timer ) * 20, height * 0.5 + math.cos( timer ) * 20, 20)

    if Debug.shown then Debug.draw(width) end

    testHitbox:draw()
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