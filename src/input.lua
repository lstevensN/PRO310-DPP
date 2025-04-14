function love.keypressed(key, scancode, isrepeat)
    -- Show Debug Info
    if key == "r" and not isrepeat then
       Debug.shown = not Debug.shown
    end

    -- Exit Program
    if key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button, istouch, presses)

end