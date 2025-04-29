Player = {}
Player.__index = Player

local PLAYER_WIDTH = 100
local PLAYER_HEIGHT = 200

function Player:new()
    local player = {
        x = 0,
        y = 0,

        width = PLAYER_WIDTH,
        height = PLAYER_HEIGHT,

        rotation = 0,

        scale = { x = 1, y = 1 },

        origin = { x = PLAYER_WIDTH/2, y = PLAYER_HEIGHT/2 },

        animations = {}
    }

    setmetatable( player, self )
    return player
end