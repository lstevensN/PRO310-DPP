if arg[2] == "debug" then
    require( "lldebugger" ).start()
end


local timer = 0
local width, height

local testHitbox, testHitbox2

local testCurve
local finishTime = 5

function love.load()
    width, height = love.graphics.getDimensions()

    love.graphics.setBackgroundColor( 1, 1, 1 )

    require( "src.animation" )
    require( "src.debug" )
    require( "src.hitbox" )
    require( "src.input" )
    require( "src.player" )

    Debug:load()

    testHitbox = Hitbox:new( 50, 100 )
    testHitbox:move( width/2, height/2 )

    testHitbox2 = Hitbox:new( 100, 50 )
    testHitbox2:move( width/2 + 50, height/2 - 50 )

    testCurve = love.math.newBezierCurve( 100, 100, 100, 620, 860, 620 )

    TestPlayer = Player:new()
    TestPlayer:move( width/2, height/2 )

    -- collectgarbage( "stop" )
end

function love.update(dt)
    timer = timer + dt
    Debug:update( dt )

    testHitbox:move( testCurve:evaluate( (timer % finishTime) / finishTime ) )

    TestPlayer:update( dt )

    -- Garbage Collection (every 3 seconds)
    if timer % 3 < 0.1 then collectgarbage( "collect" ) end
end

function love.draw()
    love.graphics.setColor( 0, 0, 0 )

    if Debug.shown then Debug:draw( width ) end

    testHitbox:draw()
    testHitbox2:draw()

    love.graphics.line( testCurve:render() )

    TestPlayer:draw()
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