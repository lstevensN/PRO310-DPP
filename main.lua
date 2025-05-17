if arg[2] == "debug" then
    require( "lldebugger" ).start()
end


local timer = 0
local width, height

local solidBox, hurtBox

local testCurve
local finishTime = 5
local hurtBoxDistanceX, hurtBoxDistanceY

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

    solidBox = Hitbox:new( 100, 50, "solid" )
    testMap:addHitbox( solidBox )
    --solidBox:rotate( math.pi/3 )
    solidBox:move( width/2 + 200, height/2 )

    hurtBox = Hitbox:new( 50, 100, "hurt" )
    testMap:addHitbox( hurtBox )
    hurtBox:move( 100, 100 )

    testCurve = love.math.newBezierCurve( 100, 100, 100, 620, 860, 620 )

    TestPlayer = Player:new( testMap )
    TestPlayer:move( width/2, height/2 )

    -- collectgarbage( "stop" )
end

function love.update(dt)
    timer = timer + dt
    Debug:update( dt )

    hurtBoxDistanceX, hurtBoxDistanceY = testCurve:evaluate( (timer % finishTime) / finishTime )
    hurtBoxDistanceX = hurtBoxDistanceX - hurtBox.x
    hurtBoxDistanceY = hurtBoxDistanceY - hurtBox.y

    hurtBox:move( hurtBoxDistanceX, hurtBoxDistanceY )

    TestPlayer:update( dt )

    testMap:update( dt )

    -- Garbage Collection (every 3 seconds)
    if timer % 3 < 0.1 then collectgarbage( "collect" ) end
end

function love.draw()
    love.graphics.setColor( 0, 0, 0 )

    if Debug.shown then
        for _, h in ipairs( testMap.colliders ) do h:draw() end
    end

    love.graphics.line( testCurve:render() )

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