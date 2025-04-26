Hitbox = {}
Hitbox.__index = Hitbox

local function CreateHitboxMesh(w, h)
    local vertices = {
        {  w/2, h/2, 0,0, 1,1,1,1 },
        {  w/2,-h/2, 0,0, 1,1,1,1 },
        { -w/2,-h/2, 0,0, 1,1,1,1 },
        { -w/2, h/2, 0,0, 1,1,1,1 }
    }

    return love.graphics.newMesh( vertices, "fan", "static" )
end

function Hitbox:update(dt)

end

function Hitbox:draw()
    love.graphics.setColor( 20/255, 200/255, 30/255, 0.4 )  -- Set color to Green

    love.graphics.draw( self.mesh, self.x, self.y, self.rotation, self.sx, self.sy )

    love.graphics.setColor( 0, 0, 0, 1 )  -- Set color to White
end

function Hitbox:new(x, y, w, h, sx, sy)
    local hitbox = {
        x = x or 0,
        y = y or 0,

        width = w or 1,
        height = h or 1,

        rotation = 0,

        sx = sx or 1,
        sy = sy or 1,

        mesh = {}
    }

    hitbox.mesh = CreateHitboxMesh( hitbox.width, hitbox.height )

    setmetatable(hitbox, self)

    return hitbox
end