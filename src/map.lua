Map = {}
Map.__index = Map

function Map:addHitbox(hitbox)
    for _, h in ipairs(self.colliders) do
        if h == hitbox then return end
    end

    table.insert( self.colliders, hitbox )
end

function Map:new(id)
    local map = {
    -- Map ID
        id = id or -1,

    -- Colliders in Scene
        colliders = {}
    }

    setmetatable( map, self )
    return map
end