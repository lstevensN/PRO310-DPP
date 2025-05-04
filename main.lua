if arg[2] == "debug" then
    require( "lldebugger" ).start()
end


local timer = 0
local width, height

local testHitbox, testHitbox2

local testCurve
local finishTime = 5
local movingHitboxDistanceX, movingHitboxDistanceY

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
    
    --testHitbox = Hitbox:new( 50, 100 )
    --testMap:addHitbox( testHitbox )
    --testHitbox:move( 100, 100 )

    testHitbox2 = Hitbox:new( 100, 50 )
    testMap:addHitbox( testHitbox2 )
    testHitbox2:move( width/2 + 50, height/2 - 50 )

    testCurve = love.math.newBezierCurve( 100, 100, 100, 620, 860, 620 )

    TestPlayer = Player:new( testMap )
    -- TestPlayer:rotate( math.pi * 1.27 )
    TestPlayer:move( width/2, height/2 )

    -- collectgarbage( "stop" )
end

function love.update(dt)
    timer = timer + dt
    Debug:update( dt )

    --movingHitboxDistanceX, movingHitboxDistanceY = testCurve:evaluate( (timer % finishTime) / finishTime )
    --movingHitboxDistanceX = movingHitboxDistanceX - testHitbox.x
    --movingHitboxDistanceY = movingHitboxDistanceY - testHitbox.y

    --testHitbox:move( movingHitboxDistanceX, movingHitboxDistanceY )

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