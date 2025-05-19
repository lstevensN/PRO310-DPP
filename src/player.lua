Player = {}
Player.__index = Player

-- CONSTANTS

local PLAYER_SPRITE_WIDTH = 150
local PLAYER_SPRITE_HEIGHT = 200

local PLAYER_COLLISION_WIDTH = 150
local PLAYER_COLLISION_HEIGHT = 200

local PLAYER_DEFAULT_SPEED = 250
local PLAYER_DEFAULT_JUMP_HEIGHT = 300


local function CreateBehaviorMapppings(player)
    return {
        -- IDLE Behavior
        ['idle'] = function (dt)
            if (not player.grounded) then
                player.dy = player.map.gravity * 3
                player.state = 'fall'
            elseif (love.keyboard.isDown( 'a' )) then
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
            if (not player.grounded) then
                player.dy = player.map.gravity * 3
                player.state = 'fall'
            elseif (love.keyboard.isDown( 'lshift' )) then
                player.state = 'run'
            elseif (love.keyboard.isDown( 'a' )) then
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
            if (not player.grounded) then
                player.dy = -player.jumpHeight
                player.state = 'fall'
            elseif (not love.keyboard.isDown( 'lshift' )) then
                player.state = 'walk'
            elseif (love.keyboard.isDown( 'a' )) then
                player.direction = 'left'
                player.dx = -player.speed * 2
            elseif (love.keyboard.isDown( 'd' )) then
                player.direction = 'right'
                player.dx = player.speed * 2
            else
                player.dx = 0
                player.state = 'idle'
                -- player.animation = player.animations['idle']
            end
        end,

        -- FALL Behavior
        ['fall'] = function (dt)
            if (player.grounded) then
                player.dy = 0
                player.state = 'idle'
            else
                player.dy = player.dy + player.map.gravity
                if (player.dy > 800) then player.dy = 800 end
            end
            
            if (player.direction == 'left' and player.dx < 0) then
                player.dx = -player.speed * 0.6
            elseif (player.direction == 'right' and player.dx > 0) then
                player.dx = player.speed * 0.6
            else
                player.dx = 0
            end
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
    self.grounded = false

    for _, collision in ipairs(self.hitboxes[2].collisions) do
        if (collision.layer == "solid") then self.grounded = true end
    end

    -- Update Player state & resolve behavior
    self.behaviors[self.state](dt)

    -- Move Player using velocity values
    self:move( self.dx * dt, self.dy * dt )

    if (love.keyboard.isDown( "q" )) then
        self:rotate( -math.pi/2 * dt )
    end

    if (love.keyboard.isDown( "e" )) then
        self:rotate( math.pi/2 * dt )
    end
end

function Player:draw()
    -- Draw Player Sprite(s)
    love.graphics.push()
    love.graphics.translate( self.x, self.y )
    love.graphics.rotate( self.rotation )
    love.graphics.rectangle( "line", 0 - self.origin.x, 0 - self.origin.y, self.width, self.height )
    love.graphics.pop()
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

    -- Jump Height
        jumpHeight = PLAYER_DEFAULT_JUMP_HEIGHT,

    -- "Grounded" Status  (is Player on ground?)
        grounded = true,

    -- Visual Dimensions
        width = PLAYER_SPRITE_WIDTH, height = PLAYER_SPRITE_HEIGHT,

    -- Sprite Origin  (center, needed for sprite flipping)
        origin = { x = PLAYER_SPRITE_WIDTH/2, y = PLAYER_SPRITE_HEIGHT/2 },

    -- Current Animation
        animation = nil,

    -- Current Animation Frame
        currentFrame = nil,
    
    -- Current Visual Direction  (determines sprite flipping)
        direction = "right",

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
    player.hitboxes[2]:move( 0, PLAYER_COLLISION_HEIGHT/2 - 8 )

    -- Initialize behavior mappings
    player.behaviors = CreateBehaviorMapppings( player )

    setmetatable( player, self )
    return player
end