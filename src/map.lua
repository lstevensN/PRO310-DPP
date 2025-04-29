Map = {}
Map.__index = Map

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