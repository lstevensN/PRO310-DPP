Map = {}
Map.__index = Map

function Map:addHitbox(hitbox)
    for _, h in ipairs(self.colliders) do
        if h == hitbox then return end
    end

    table.insert( self.colliders, hitbox )
end

function Map:update(dt)
    for _, hitbox1 in ipairs( self.colliders ) do
        for _, hitbox2 in ipairs( self.colliders ) do
            if (hitbox1 ~= hitbox2) then
                hitbox1:CheckCollision( hitbox2 )
            end
        end
    end
end

function Map:new(id)
    local map = {
    -- Map ID
        id = id or -1,

    -- Colliders/Hitboxes in Scene
        colliders = {}
    }

    setmetatable( map, self )
    return map
end