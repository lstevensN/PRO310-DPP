if arg[2] == "debug" then
    require( "lldebugger" ).start()
end


local timer = 0
local width, height

local ground

local testMap

function love.load()
    width, height = love.graphics.getDimensions()

    love.graphics.setBackgroundColor( 1, 1, 1 )

    require( "src.animation" )
    require( "src.debug" )
    require( "src.hitbox" )
    require( "src.input" )
    require( "src.map" )
    require( "src.math" )
    require( "src.player" )

    Debug:load()

    testMap = Map:new( 0 )
    CurrentMap = testMap

    ground = Hitbox:new( 1000, 50, "solid" )
    testMap:addHitbox( ground )
    ground:move( width/2, 600 )

    TestPlayer = Player:new( testMap )
    TestPlayer:move( width/2, 300 )

    -- collectgarbage( "stop" )
end

function love.update(dt)
    timer = timer + dt
    Debug:update( dt )

    TestPlayer:update( dt )

    testMap:update( dt )

    -- Garbage Collection (every 3 seconds)
    if timer % 3 < 0.1 then collectgarbage( "collect" ) end
end

function love.draw()
    love.graphics.setColor( 0, 0, 0 )

    love.graphics.line( 0, 575, width, 575 )

    if Debug.shown then
        for _, h in ipairs( testMap.colliders ) do h:draw() end
    end

    TestPlayer:draw()

    Debug:draw( width )
end


local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
---@diagnostic disable-next-line: undefined-global
    if lldebugger then
        error( msg, 2 )
    else
        return love_errorhandler( msg )
    end
end