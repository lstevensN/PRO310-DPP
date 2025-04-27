Debug = { shown = false }
Debug.__index = Debug

local memory_used

function Debug:load()
    local font = love.graphics.getFont()
    memory_used = love.graphics.newText( font, "" )
end

function Debug:update(dt)
    memory_used:set( 'Memory usage: ' .. math.floor( collectgarbage( 'count' ) ) .. ' kB' )
end

function Debug:draw(width)
    love.graphics.setColor( 0, 0, 0 )
    love.graphics.rectangle( "fill", 0, 0, width, 35 )

    love.graphics.setColor( 1, 1, 1 )
    love.graphics.print( tostring( love.timer.getFPS( ) ).." FPS", 20, 10 )
    love.graphics.draw( memory_used, width - 20 - memory_used:getWidth(), 10 )
end