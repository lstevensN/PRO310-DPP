Animation = {}
Animation.__index = Animation

function Animation:update(dt)
    self.timer = self.timer + dt

    while (self.timer > self.fps) do
        self.timer = self.timer - self.interval
        self.currentFrame = (self.currentFrame + 1) % #self.frames

        if (self.currentFrame == 0) then self.currentFrame = 1 end
    end
end

function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end

function Animation:restart()
    self.timer = 0
    self.currentFrame = 1
end

--> Constructor
function Animation:new(params)
    local animation = {
    -- Animation Texture
        texture = params.texture,

    -- Animation Quads
        frames = params.frames or {},

    -- Framerate (FPS)
        interval = params.interval or 0.05,

    -- Internal Timer
        timer = 0,

    -- Current Animation Frame
        currentFrame = 1
    }

    setmetatable( animation, self )

    return animation
end