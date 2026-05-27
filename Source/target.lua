-- Target sprite: the goal the player must reach to advance to the next level.

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx = playdate.graphics
local pd = playdate

class('Target').extends(gfx.sprite)

function Target:init(x, y)
    local ballImage = gfx.image.new("images/target.png")
    self:setImage(ballImage)

    -- Collision rect inset by 10px to require a more precise hit
    self:setCollideRect(10, 10, 10, 10)
    self:moveTo(x, y)
    self:add()
end

function Target:collisionResponse(other)
    return gfx.sprite.kCollisionTypeOverlap
end