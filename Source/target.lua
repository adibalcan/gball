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

    self:setCollideRect(10, 10, 10, 10)
    self:moveTo(x, y)
    self:add()
end

function Target:collisionResponse(other)
    return gfx.sprite.kCollisionTypeOverlap
end