Player = {}
Player.__index = Player

-- CONSTANTS

local PLAYER_SPRITE_WIDTH = 100
local PLAYER_SPRITE_HEIGHT = 200

local PLAYER_COLLISION_WIDTH = 100
local PLAYER_COLLISION_HEIGHT = 200

local PLAYER_DEFAULT_SPEED = 150


local function CreateBehaviorMapppings(player)
    return {
        -- IDLE Behavior
        ['idle'] = function (dt)
            if (love.keyboard.isDown( 'a' )) then
                player.direction = 'left'
                player.dx = -player.speed
                player.state = 'walk'
                -- player.animations['walk']:restart()
                -- player.animation = player.animations['walk']
            elseif (love.keyboard.isDown( 'd' )) then
                player.direction = 'right'
                player.dx = player.speed
                player.state = 'walk'
                -- player.animations['walk']:restart()
                -- player.animation = player.animations['walk']
            else
                player.dx = 0
            end
        end,

        -- WALK Behavior
        ['walk'] = function (dt)
            if (love.keyboard.isDown( 'a' )) then
                player.direction = 'left'
                player.dx = -player.speed
            elseif (love.keyboard.isDown( 'd' )) then
                player.direction = 'right'
                player.dx = player.speed
            else
                player.dx = 0
                player.state = 'idle'
                -- player.animation = player.animations['idle']
            end
        end,

        -- RUN Behavior
        ['run'] = function (dt)

        end,

        -- FALL Behavior
        ['fall'] = function (dt)
            
        end,

        -- ATTACK Behavior
        ['attack'] = function (dt)
            
        end
    }
end

function Player:rotate(rotate)
    -- Rotate self
    self.rotation = self.rotation + rotate

    -- Rotate hitboxes
    for _, hitbox in ipairs(self.hitboxes) do hitbox:rotate( rotate, self.x, self.y ) end
end

function Player:move(xDistance, yDistance)
    -- Move self
    self.x = self.x + xDistance
    self.y = self.y + yDistance

    -- Move hitboxes
    for _, hitbox in ipairs(self.hitboxes) do hitbox:move( xDistance, yDistance ) end
end

function Player:update(dt)
    -- Update Player state & resolve behavior
    self.behaviors[self.state](dt)

    -- Move Player using velocity values
    self:move( self.dx * dt, self.dy * dt )

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

--> Constructor
function Player:new(map)
    local player = {
    -- World Position
        x = 0, y = 0,

    -- World Rotation
        rotation = 0,

    -- World Scale
        scale = { x = 1, y = 1 },

    -- Velocity
        dx = 0, dy = 0,

    -- Move Speed
        speed = PLAYER_DEFAULT_SPEED,

    -- Visual Dimensions
        width = PLAYER_SPRITE_WIDTH, height = PLAYER_SPRITE_HEIGHT,

    -- Sprite Origin  (center, needed for sprite flipping)
        origin = { x = PLAYER_SPRITE_WIDTH/2, y = PLAYER_SPRITE_HEIGHT/2 },

    -- Current Animation
        animation = nil,

    -- Current Animation Frame
        currentFrame = nil,
    
    -- Current Visual Direction  (determines sprite flipping)
        direction = "left",

    -- Current State
        state = "idle",

    -- Collision Hitboxes
        hitboxes = {},

    -- Current Map
        map = map or nil
    }

    -- Initialize hitboxes
    table.insert( player.hitboxes, Hitbox:new( PLAYER_COLLISION_WIDTH, PLAYER_COLLISION_HEIGHT, "rigid", player ) )
    table.insert( player.hitboxes, Hitbox:new( PLAYER_COLLISION_WIDTH - 10, 20, "touch", player ) )
    player.hitboxes[2]:move( 0, PLAYER_COLLISION_HEIGHT/2 - 5 )

    -- Initialize behavior mappings
    player.behaviors = CreateBehaviorMapppings( player )

    setmetatable( player, self )
    return player
end