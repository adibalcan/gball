import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx = playdate.graphics
local pd = playdate

class('Trap').extends(gfx.sprite)

function Trap:init(x, y)
    local ballImage = gfx.image.new("images/trap.png")
    self:setImage(ballImage)

    self:setCollideRect(10, 10, 10, 10)
    self:moveTo(x, y)
    self:add()
end

function Trap:collisionResponse(other)
    return gfx.sprite.kCollisionTypeOverlap
end