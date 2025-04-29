Hitbox = {}
Hitbox.__index = Hitbox

local function CreateHitboxMesh(ox, oy)
    local vertices = {
        {  ox, oy, 0,0, 1,1,1,1 },
        {  ox,-oy, 0,0, 1,1,1,1 },
        { -ox,-oy, 0,0, 1,1,1,1 },
        { -ox, oy, 0,0, 1,1,1,1 }
    }

    return love.graphics.newMesh( vertices, "fan", "static" )
end

function Hitbox:update(dt)
    if self.layer == "touch" then

    elseif self.layer == "damage" then

    end
end

function Hitbox:draw()
    if #self.collisions > 0 then love.graphics.setColor( 1, 0, 0, 0.4 )  -- Set color to Red
    else love.graphics.setColor( 20/255, 200/255, 30/255, 0.4 )  -- Set color to Green
    end

    love.graphics.draw( self.mesh, self.x, self.y, self.rotation, self.scaleX, self.scaleY )

    love.graphics.setColor( 0, 0, 0, 1 )  -- Set color to Black

    love.graphics.circle( "fill", self.x, self.y, 3 )
end

function Hitbox:move(x, y)
    self.x = x
    self.y = y
end

function Hitbox:new(width, height, layer)
    local hitbox = {
    -- Collision Layer
    --- "touch": area with collision detection on touch
    --- "damage": area that deals damage on touch
        layer = layer or "touch",

    -- Global Position
        x = 0, y = 0,

    -- Global Rotation
        rotation = 0,
    
    -- Global Scale
        scale = { x = 1, y = 1 },

    -- Box Dimensions
        width = width or 1, height = height or 1,

    -- Box Origin  (center)
        origin = {},

    -- Box Mesh
        mesh = {},

    -- Current Collisions
        collisions = {}
    }

    hitbox.origin = { x = hitbox.width/2, y = hitbox.height/2 }

    hitbox.mesh = CreateHitboxMesh( hitbox.origin.x, hitbox.origin.y )

    setmetatable( hitbox, self )

    return hitbox
end