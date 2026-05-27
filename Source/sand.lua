-- Sand terrain: slows the ball while overlapping.

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx = playdate.graphics

class('Sand').extends(gfx.sprite)

function Sand:init(x, y)
    local sandImage = gfx.image.new("images/sand.png")
    self:setImage(sandImage)

    self:setCollideRect(0, 0, sandImage.w, sandImage.h)
    self:moveTo(x, y)
    self:add()
end

function Sand:collisionResponse(other)
    return gfx.sprite.kCollisionTypeOverlap
end
