-- Player-controlled ball that moves via the accelerometer and handles collisions.

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "target"
import "trap"
import "sand"
import "ice"
import "textDisplay"

local gfx = playdate.graphics
local pd = playdate

-- Required to enable accelerometer readings for tilt-based movement
pd.startAccelerometer()

-- Terrain speed modifier: updated each frame based on sand/ice overlap
speedMultiplier = 1.0

class('Ball').extends(gfx.sprite)

function Ball:init(x, y)
    initialX = x
    initialY = y

    local ballImage = gfx.image.new("images/ball.png")
    self:setImage(ballImage)
    self:setCollideRect(10, 10, 10, 10)

    self:moveTo(x, y)
    self:setZIndex(100)
    self:add()
end

function isWithinBounds(x, y)
    -- Allow 30px margin beyond the 400x240 screen before stopping movement
    local margin = 30
    return x > -margin and x < 400 + margin and y > -margin and y < 240 + margin
end

-- Called every frame by the sprite system
function Ball:update(x, y)
    if status == 1 then
        local gravityX, gravityY, _gravityZ = playdate.readAccelerometer()

        -- Apply terrain speed modifier from previous frame's overlaps
        local effectiveSensitivity = sensitivity * speedMultiplier

        local newX = self.x + gravityX * effectiveSensitivity
        local newY = self.y + gravityY * effectiveSensitivity

        -- Reset each frame; collisions below will set it again if still overlapping
        speedMultiplier = 1.0

        if isWithinBounds(newX, newY) then
            local x, y, collisions, length = self:moveWithCollisions(newX, newY)

            if length > 0 then
                for index, collision in pairs(collisions) do
                    local colidedObject = collision['other']
                    if colidedObject:isa(Target) then
                        -- Snap ball onto the target for visual feedback
                        self:moveWithCollisions(colidedObject.x, colidedObject.y)
                        prepareNextLevel()
                        updateText(prefix .. "Success! Score:" .. score .. " Press A for next level!")
                    elseif colidedObject:isa(Trap) then
                        self:moveWithCollisions(colidedObject.x, colidedObject.y)
                        updateText(prefix .. "Game over! Score:" .. score .. " Press A to start again")
                        resetGame()
                    elseif colidedObject:isa(Sand) then
                        speedMultiplier = 0.4
                    elseif colidedObject:isa(Ice) then
                        speedMultiplier = 2.0
                    end
                end
            end
        end
    end
end

function Ball:resetPosition()
    self:moveTo(initialX, initialY)
end

-- Overlap instead of bounce so the ball passes through and triggers game logic
function Ball:collisionResponse(other)
    return gfx.sprite.kCollisionTypeOverlap
end

