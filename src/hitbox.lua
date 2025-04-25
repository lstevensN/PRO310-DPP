local Hitbox = {}

local function CreateHitboxMesh(w, h)
    local vertices = {
        {  w/2, h/2, 0,0, 1,1,1,1 },
        {  w/2,-h/2, 0,0, 1,1,1,1 },
        { -w/2,-h/2, 0,0, 1,1,1,1 },
        { -w/2, h/2, 0,0, 1,1,1,1 }
    }

    return love.graphics.newMesh( vertices, "fan", "static" )
end

local function InitializeHitbox(self, x, y, w, h, sx, sy)
    self.x, self.y = x or 0, y or 0
    self.width, self.height = w or 1, h or 1
    self.rotation = 0
    self.sx, self.sy = sx or 1, sy or 1

    self.mesh = CreateHitboxMesh( self.width, self.height )
end

function Hitbox:update(dt)

end

function Hitbox:draw()
    love.graphics.setColor( 20/255, 200/255, 30/255, 0.4 )  -- Set color to Green

    love.graphics.draw( self.mesh, self.x, self.y, self.rotation, self.sx, self.sy )

    love.graphics.setColor( 0, 0, 0, 1 )  -- Set color to White
end

function Hitbox:new(x, y, w, h, sx, sy)
    local newHitbox = Hitbox

    InitializeHitbox( newHitbox, x, y, w, h, sx, sy )

    return newHitbox
end

return Hitbox