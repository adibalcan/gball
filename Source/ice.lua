-- Ice terrain: speeds up the ball while overlapping.

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx = playdate.graphics

class('Ice').extends(gfx.sprite)

function Ice:init(x, y)
    local iceImage = gfx.image.new("images/ice.png")
    self:setImage(iceImage)
    self:setCollideRect(0, 0, iceImage.w, iceImage.h)
    self:moveTo(x, y)
    self:add()
end

function Ice:collisionResponse(other)
    return gfx.sprite.kCollisionTypeOverlap
end
