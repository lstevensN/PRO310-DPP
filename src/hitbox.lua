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
    -- THANK YOU https://dyn4j.org/2010/01/sat/ SO MUCH FOR THE HELP AAAAAAAAA
    -- I LOVE YOU <3

    local overlap = 5000  -- Set to really big number by default
    local smallestAxis

    -- Get the axes of both hitboxes
    local axes1 = h1:getAxes()
    local axes2 = h2:getAxes()

    -- Check hitbox #1's axes
    for _, axis in ipairs( axes1 ) do
        -- Project both hitboxes onto the axis
        local p1 = h1:project( axis )
        local p2 = h2:project( axis )

        -- Check if projections overlap
        if (not (p1.min < p2.min and p2.min < p1.max) and not (p2.min < p1.min and p1.min < p2.max)) then
            return false -- Hitboxes are certainly NOT colliding, so we can confidently (and safely) return
        else
            local o = p1.getOverlap( p2 )

            -- Check if either projection contains the other
            if ((p1.min < p2.min and p2.max < p1.max) or (p2.min < p1.min and p1.max < p2.max)) then
                local mins = math.abs( p1.min - p2.min )
                local maxs = math.abs( p1.max - p2.max )

                if (mins < maxs) then
                    o = o + mins
                else
                    o = o + maxs
                end
            end

            -- Ensure we have the smallest axis
            if (o < overlap) then
                overlap = o
                smallestAxis = axis
            end
        end
    end

    -- Check hitbox #2's axes
    for _, axis in ipairs( axes2 ) do
        -- Project both hitboxes onto the axis
        local p1 = h1:project( axis )
        local p2 = h2:project( axis )

        -- Check if projections overlap
        if (not (p1.min < p2.min and p2.min < p1.max) and not (p2.min < p1.min and p1.min < p2.max)) then
            return false -- Hitboxes are certainly NOT colliding, so we can confidently (and safely) return
        else
            local o = p1.getOverlap( p2 )

            -- Check if either projection contains the other
            if ((p1.min < p2.min and p2.max < p1.max) or (p2.min < p1.min and p1.max < p2.max)) then
                local mins = math.abs( p1.min - p2.min )
                local maxs = math.abs( p1.max - p2.max )

                if (mins < maxs) then
                    o = o + mins
                else
                    o = o + maxs
                end
            end

            -- Ensure we have the smallest axis
            if (o < overlap) then
                overlap = o
                smallestAxis = axis
            end
        end
    end

    -- Could use some tweaking, but I'll take it for now! :D
    H1toH2 = { x = h1.x - h2.x, y = h1.y - h2.y }
    if ((smallestAxis.direction.x < 0 and H1toH2.x > 0) or (smallestAxis.direction.x > 0 and H1toH2.x < 0)) then smallestAxis.direction.x = -smallestAxis.direction.x end
    if ((smallestAxis.direction.y < 0 and H1toH2.y > 0) or (smallestAxis.direction.y > 0 and H1toH2.y < 0)) then smallestAxis.direction.y = -smallestAxis.direction.y end

    -- Returns result of collision test & Minimum Translation Value (MTV) data
    return true, { overlap = overlap, axis = smallestAxis }
end

function Hitbox:project( axis )
    local vertices = self:getVertices()

    local min = VectorDotAxis( vertices[1], axis )
    local max = min

    for _, vertex in ipairs( vertices ) do
        local p = VectorDotAxis( vertex, axis )

        if (p < min) then min = p
        elseif (p > max) then max = p end
    end

    return { min = min, max = max, getOverlap = function (other) return math.min( max, other.max ) - math.max( min, other.min ) end }
end

function Hitbox:getAxes()
    local OX = { x = 1, y = 0 }
    local OY = { x = 0, y = 1 }
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

function Hitbox:getVertices()
    local vertices = {}

    for i = 1, 4 do
        local x, y = self.mesh:getVertex( i )

        local vertex = VectorRotate( { x = x * self.scale.x, y = y * self.scale.x }, self.rotation )
        vertex = AddVectors( vertex, { x = self.x, y = self.y } )

        table.insert( vertices, vertex )
    end

    return vertices
end

function Hitbox:checkCollision(other)
    -- Check if hitboxes are colliding
    local colliding, mtv = IsProjectionCollide( self, other )

    if (colliding) then
        if (other.layer == "solid" and self.parent ~= nil and mtv ~= nil) then
            local adjustment = VectorMultiply( mtv.axis.direction, mtv.overlap )
            self.parent:move( adjustment.x, adjustment.y )
        end

        -- Check if other hitbox is already in "collisions" list
        local alreadyRegistered = false

        for _, v in ipairs( self.collisions ) do
            if v == other then alreadyRegistered = true break end
        end

        -- If not, add it
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

--> Constructor
function Hitbox:new(width, height, layer, parent)
    local hitbox = {
    -- Collision Layer
    --- "touch": area with collision detection on touch
    --- "solid": area that applies resistance on touch (immobile object)
    --- "hurt": area that deals damage on touch
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
        collisions = {},

    -- Parent/Owner
        parent = parent or nil
    }

    hitbox.origin = { x = hitbox.width/2, y = hitbox.height/2 }

    hitbox.mesh = CreateHitboxMesh( hitbox.origin.x, hitbox.origin.y )

    setmetatable( hitbox, self )

    return hitbox
end