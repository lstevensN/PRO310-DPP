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

end

function Hitbox:draw()
    love.graphics.setColor( 20/255, 200/255, 30/255, 0.4 )  -- Set color to Green

    love.graphics.draw( self.mesh, self.x, self.y, self.rotation, self.scaleX, self.scaleY )

    love.graphics.setColor( 0, 0, 0, 1 )  -- Set color to Black
end

function Hitbox:new(x, y, w, h, sx, sy)
    local hitbox = {
        x = x or 0,
        y = y or 0,

        width = w or 1,
        height = h or 1,

        originX = 0.5,
        originY = 0.5,

        rotation = 0,

        scaleX = sx or 1,
        scaleY = sy or 1,

        mesh = {}
    }

    hitbox.originX = hitbox.width / 2
    hitbox.originY = hitbox.height / 2

    hitbox.mesh = CreateHitboxMesh( hitbox.originX, hitbox.originY )

    setmetatable( hitbox, self )

    return hitbox
end