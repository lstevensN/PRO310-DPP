Player = {}
Player.__index = Player

-- CONSTANTS
local PLAYER_SPRITE_WIDTH = 100
local PLAYER_SPRITE_HEIGHT = 200

local PLAYER_COLLISION_WIDTH = 100
local PLAYER_COLLISION_HEIGHT = 200

local PLAYER_DEFAULT_SPEED = 150


function Player:move(x, y)
    self.x = x - self.origin.x
    self.y = y - self.origin.y
end

function Player:update(dt)
    -- Simple Player Controls
    if love.keyboard.isDown( "a" ) then self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown( "d" ) then self.x = self.x + self.speed * dt end

    self.hitbox:move( self.x, self.y )
end

function Player:draw()
    -- Draw Player Sprite(s)
    love.graphics.circle( "fill", self.x, self.y, 3 )

    if Debug.shown then self.hitbox:draw() end
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

    player.map:addHitbox( player.hitbox )

    setmetatable( player, self )
    return player
end