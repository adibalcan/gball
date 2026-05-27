import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "target"
import "trap"
import "textDisplay"
--import "main"

local gfx = playdate.graphics
local pd = playdate

pd.startAccelerometer()

class('Ball').extends(gfx.sprite)

function Ball:init(x, y)
    initialX = x
    initialY = y

    local ballImage = gfx.image.new("images/ball.png")
    self:setImage(ballImage)
    self:setCollideRect(10, 10, 10, 10)
    
    self:moveTo(x, y)
    self:add()
end

function Ball:update(x, y)
    if status == 1 then
        local gravityX, gravityY, _gravityZ = playdate.readAccelerometer()
        
        local newX = self.x + gravityX * sensitivity
        local newY = self.y + gravityY * sensitivity


        if newX > -30 and newX < 400 + 30 and newY > -30 and newY < 240 + 30 then
            local x, y, collisions, length = self:moveWithCollisions(newX, newY) 
        
            if length > 0 then
                for index, collision in pairs(collisions) do
                    local colidedObject = collision['other']
                    if colidedObject:isa(Target) then
                        self:moveWithCollisions(colidedObject.x, colidedObject.y)
                        prepareNextLevel() -- compute score and others
                        updateText(prefix .. "Success! Score:" .. score .. " Press A for next level!")
                    end

                    if colidedObject:isa(Trap) then
                        self:moveWithCollisions(colidedObject.x, colidedObject.y)
                        updateText(prefix .. "Game over! Score:" .. score .. " Press A to start again")
                        resetGame() -- reset socore and end game
                        
                    end
                end
            end
        end
    end 
end

function Ball:resetPosition()
    self:moveTo(initialX, initialY)
end


function Ball:collisionResponse(other)
    return gfx.sprite.kCollisionTypeOverlap
end

