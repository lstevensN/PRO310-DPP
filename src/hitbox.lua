Hitbox = {}
Hitbox.__index = Hitbox

local drawQueue = {}

local function CreateHitboxMesh(ox, oy)
    local vertices = {
        {  ox, oy, 0,0, 1,1,1,1 },
        {  ox,-oy, 0,0, 1,1,1,1 },
        { -ox,-oy, 0,0, 1,1,1,1 },
        { -ox, oy, 0,0, 1,1,1,1 }
    }

    return love.graphics.newMesh( vertices, "fan", "static" )
end

local function IsProjectionCollide(h1, h2)
    local lines = h2:getAxis()
    local corners = h1:getCorners()

    local isCollide = true

    for dimension, line in ipairs( lines ) do
        local futhers = { min = nil, max = nil }

        local h2BoxHalfSize
        if (dimension == 1) then
            h2BoxHalfSize = h2.origin.x
        else
            h2BoxHalfSize = h2.origin.y
        end

        for _, corner in ipairs(corners) do
            local projected = VectorProject( corner, line )
            local CP = SubtractVectors( projected, { x = h2.x, y = h2.y } )

            local sign = (CP.x * line.direction.x) + (CP.y * line.direction.y) > 0
            local signedDistance = VectorMagnitude( CP )
            if (sign == false) then signedDistance = signedDistance * -1 end
        
            if (not futhers.min or futhers.min.signedDistance > signedDistance) then
                futhers.min = { signedDistance = signedDistance, corner = corner, projected = projected }
            end

            if (not futhers.max or futhers.max.signedDistance < signedDistance) then
                futhers.max = { signedDistance = signedDistance, corner = corner, projected = projected }
            end

            local absMinSignedDistance = math.abs( futhers.min.signedDistance )
            local absMaxSignedDistance = math.abs( futhers.max.signedDistance )

            local projectionColide = ((futhers.min.signedDistance < 0 and futhers.max.signedDistance > 0 or
                absMinSignedDistance < h2BoxHalfSize or absMaxSignedDistance < h2BoxHalfSize))

            if (projectionColide == false) then isCollide = projectionColide end
            

            table.insert( drawQueue, function ()
                love.graphics.setColor( 0, 0, 0, 1 )
                love.graphics.circle( "fill", corner.x, corner.y, 2 )

                love.graphics.setColor( 0, 0, 1, 0.05 )

                love.graphics.circle( "fill", futhers.min.projected.x, futhers.min.projected.y, 2 )
                love.graphics.line( futhers.min.corner.x, futhers.min.corner.y, futhers.min.projected.x, futhers.min.projected.y )
                
                love.graphics.circle( "fill", futhers.max.projected.x, futhers.max.projected.y, 2 )
                love.graphics.line( futhers.max.corner.x, futhers.max.corner.y, futhers.max.projected.x, futhers.max.projected.y )

                if (projectionColide == true) then love.graphics.setColor( 1, 0, 0, 1 ) end
                love.graphics.line( futhers.min.projected.x, futhers.min.projected.y, futhers.max.projected.x, futhers.max.projected.y )

                if (dimension == 1) then love.graphics.setColor( 1, 0, 1, 0.1 ) else love.graphics.setColor( 1, 140/255, 0, 0.1 ) end
                love.graphics.line( line.origin.x, line.origin.y, h2.x + line.direction.x * 500, h2.y + line.direction.y * 500 )
            end )
        end
    end

    return isCollide
end

function Hitbox:getAxis()
    local OX = { x = 1, y = 0 }
    local OY = { x = 0, y = -1 }
    local RX = VectorRotate( OX, self.rotation )
    local RY = VectorRotate( OY, self.rotation )

    return {
        {
            origin = { x = self.x, y = self.y },
            direction = { x = RX.x, y = RX.y }
        },
        {
            origin = { x = self.x, y = self.y },
            direction = { x = RY.x, y = RY.y }
        }
    }
end

function Hitbox:getCorners()
    local C1 = { x =  self.origin.x, y =  self.origin.y }
    local C2 = { x = -self.origin.x, y =  self.origin.y }
    local C3 = { x = -self.origin.x, y = -self.origin.y }
    local C4 = { x =  self.origin.x, y = -self.origin.y }

    C1 = VectorRotate( C1, self.rotation )
    C2 = VectorRotate( C2, self.rotation )
    C3 = VectorRotate( C3, self.rotation )
    C4 = VectorRotate( C4, self.rotation )

    C1 = AddVectors( C1, { x = self.x, y = self.y } )
    C2 = AddVectors( C2, { x = self.x, y = self.y } )
    C3 = AddVectors( C3, { x = self.x, y = self.y } )
    C4 = AddVectors( C4, { x = self.x, y = self.y } )

    return { C1, C2, C3, C4 }
end

function Hitbox:CheckCollision(other)
    if (IsProjectionCollide( self, other )) then
        local alreadyRegistered = false

        for _, v in ipairs( self.collisions ) do
            if v == other then
                alreadyRegistered = true
                break
            end
        end

        if (not alreadyRegistered) then table.insert( self.collisions, other ) end
    else
        for i, v in ipairs( self.collisions ) do
            if v == other then table.remove( self.collisions, i ) end
        end
    end
end

function Hitbox:update(dt)
    
end

function Hitbox:draw()
    if #self.collisions > 0 then love.graphics.setColor( 1, 0, 0, 0.4 )  -- Set color to Red
    else love.graphics.setColor( 20/255, 200/255, 30/255, 0.4 )  -- Set color to Green
    end

    love.graphics.draw( self.mesh, self.x, self.y, self.rotation, self.scaleX, self.scaleY )

    for _, drawing in ipairs( drawQueue ) do
        drawing()
    end
    drawQueue = {}

    love.graphics.setColor( 0, 0, 0, 1 )  -- Set color to Black

    love.graphics.circle( "fill", self.x, self.y, 3 )
end

function Hitbox:rotate(rotate)
    self.rotation = self.rotation + rotate
end

function Hitbox:move(xDistance, yDistance)
    self.x = self.x + xDistance
    self.y = self.y + yDistance
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