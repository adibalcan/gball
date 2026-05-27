-- HUD text rendering: draws status messages as a sprite in the top-left corner.

local pd <const> = playdate
local gfx <const> = pd.graphics

local textSprite

function createTextDisplay()
    textSprite = gfx.sprite.new()
    updateDisplay()
    textSprite:setCenter(0, 0)
    textSprite:moveTo(2, 2)
    textSprite:add()
end

function updateDisplay()
    local text = "Status: " ..status
    local textWidth, textHeight = gfx.getTextSize(text)
    -- Render text to an offscreen image, then assign it to the sprite
    local textImage = gfx.image.new(textWidth, textHeight)
    gfx.pushContext(textImage)
        gfx.drawText(text, 0, 0)
    gfx.popContext()
    textSprite:setImage(textImage)
end

function updateText(text)
    local textWidth, textHeight = gfx.getTextSize(text)
    local textImage = gfx.image.new(textWidth, textHeight)
    gfx.pushContext(textImage)
        gfx.drawText(text, 0, 0)
    gfx.popContext()
    textSprite:setImage(textImage)
end