Player = {}
Player.__index = Player

-- CONSTANTS
local PLAYER_SPRITE_WIDTH = 100
local PLAYER_SPRITE_HEIGHT = 200

local PLAYER_COLLISION_WIDTH = 100
local PLAYER_COLLISION_HEIGHT = 200

local PLAYER_DEFAULT_SPEED = 150

function Player:rotate(rotate)
    self.rotation = self.rotation + rotate

    self.hitbox:rotate( rotate )
end

function Player:move(xDistance, yDistance)
    self.x = self.x + xDistance
    self.y = self.y + yDistance

    self.hitbox:move( xDistance, yDistance )
end

function Player:update(dt)
    -- Simple Player Controls
    if love.keyboard.isDown( "a" ) then
        self:move( -self.speed * dt, 0 )
    end

    if love.keyboard.isDown( "d" ) then
        self:move( self.speed * dt, 0 )
    end

    if love.keyboard.isDown( "w" ) then
        self:move( 0, -self.speed * dt )
    end

    if love.keyboard.isDown( "s" ) then
        self:move( 0, self.speed * dt )
    end

    if (love.keyboard.isDown( "q" )) then
        self:rotate( -math.pi/2 * dt )
    end

    if (love.keyboard.isDown( "e" )) then
        self:rotate( math.pi/2 * dt )
    end
end

function Player:draw()
    -- Draw Player Sprite(s)
    love.graphics.circle( "fill", self.x, self.y, 3 )
end

function Player:new(map)
    local player = {
    -- World Position
        x = 0, y = 0,

    -- World Rotation
        rotation = 0,

    -- World Scale
        scale = { x = 1, y = 1 },

    -- Move Speed
        speed = PLAYER_DEFAULT_SPEED,

    -- Visual Dimensions
        width = PLAYER_SPRITE_WIDTH, height = PLAYER_SPRITE_HEIGHT,

    -- Sprite Origin  (center, needed for sprite flipping)
        origin = { x = PLAYER_SPRITE_WIDTH/2, y = PLAYER_SPRITE_HEIGHT/2 },

    -- Animation Frames
        frames = {},

    -- Current Animation Frame
        currentFrame = nil,
    
    -- Current Visual Direction  (determines sprite flipping)
        direction = "left",

    -- Current State
        state = "idle",

    -- Primary Collision Hitbox
        hitbox = Hitbox:new( PLAYER_COLLISION_WIDTH, PLAYER_COLLISION_HEIGHT ),

    -- Current Map
        map = map or nil
    }

    player.hitbox:move( player.x, player.y )
    player.map:addHitbox( player.hitbox )

    setmetatable( player, self )
    return player
end