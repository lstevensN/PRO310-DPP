Player = {}
Player.__index = Player

function Player:new(x, y, w, h)
    local player = {
        x = x or 0,
        y = y or 0,

        width = w or 1,
        height = h or 1
    }

    setmetatable( player, self )
    return player
end