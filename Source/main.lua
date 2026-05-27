import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx = playdate.graphics
local pd = playdate

import "textDisplay"
import "ball"
import "target"
import "trap"
import "util"

score = 0
status = 0
prefix = ""
if simulator then -- doesn't work
    prefix = "SIM:"
    senzitivity = 10
else
    sensitivity = 30
end

math.randomseed(playdate.getSecondsSinceEpoch())

-- level 1
player = Ball(30, 30)
numberOfElements = 3
elements = {}
positions = {}

createTextDisplay()
updateText("Press A to start")

function playdate.update()
    playdate.drawFPS(0,0)  
    gfx.sprite.update()
    pd.timer.updateTimers()

    if pd.buttonJustPressed(pd.kButtonA) then
        status = 1
        updateText("Play! Score:" .. score)
        playLevel()
    end

    if pd.buttonJustPressed(pd.kButtonB) then
        local change, accleratedChange = pd.getCrankChange()
        sensitivity += change
        updateText("Sensitivity " .. sensitivity)
    end
end

function resetGame()
    status = 0 -- pause game
    score = 0
    numberOfElements = 3
    sensitivity = 30

end

function prepareNextLevel()
    status = 0 -- pause game
    score += 1
    sensitivity += 3
    numberOfElements += 1
end

function playLevel()
    -- score = 0
    player:resetPosition()
    generateLevel()
end

function getRandomPosition()
    local randomX = math.random(2, 11)
    local randomY = math.random(2, 7)
    local position = {randomX, randomY}
    return position
end

function generateLevel()
    -- delete old elements
    for i=1, #elements do
        elements[i]:remove()
    end
    positions = {}

    
    for i=1,numberOfElements do
        position = getRandomPosition()
        
        while hasValue(positions, position) do
            position = getRandomPosition()
        end

        table.insert(positions, position) -- add position in table

        -- draw every trap
        if i==1 then
            elements[i] = Target(position[1] * 30, position[2] * 30)
        else
            elements[i] = Trap(position[1] * 30, position[2] * 30)
        end
        
        
    end
end

function hasValue (tab, val)
    -- check if a value is present in a table
    for index, value in ipairs(tab) do
        if is_table_equal(value, val, false) then
            return true
        end
    end
    return false
end