-- Game entry point: manages game state, input handling, and level generation.

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
import "sand"
import "ice"
import "util"

-- Game state: 0 = paused/menu, 1 = playing
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

-- Initialize the player at top-left corner of the 30px grid
player = Ball(30, 30)
numberOfElements = 3 -- starts with 1 target + 2 traps, grows each level
elements = {}
positions = {}

createTextDisplay()
updateText("Press A to start")

function playdate.update()
    playdate.drawFPS(0,0)
    gfx.sprite.update()
    pd.timer.updateTimers()

    -- A button starts or restarts a level
    if pd.buttonJustPressed(pd.kButtonA) then
        status = 1
        updateText("Play! Score:" .. score)
        playLevel()
    end

    -- B button + crank allows tuning tilt sensitivity mid-game
    if pd.buttonJustPressed(pd.kButtonB) then
        local change, accleratedChange = pd.getCrankChange()
        sensitivity += change
        updateText("Sensitivity " .. sensitivity)
    end
end

function resetGame()
    status = 0
    score = 0
    numberOfElements = 3
    sensitivity = 30
end

-- Advances difficulty: more obstacles and higher tilt sensitivity each level
function prepareNextLevel()
    status = 0
    score += 1
    sensitivity += 3
    numberOfElements += 1
end

function playLevel()
    player:resetPosition()
    generateLevel()
end

-- Returns a random grid cell (avoids the top-left where the player spawns)
function getRandomPosition()
    local randomX = math.random(2, 11)
    local randomY = math.random(2, 7)
    local position = {randomX, randomY}
    return position
end

function generateLevel()
    -- Remove sprites from the previous level
    for i=1, #elements do
        elements[i]:remove()
    end
    positions = {}

    -- Place elements on unique grid cells; first is the target, rest are traps
    for i=1,numberOfElements do
        position = getRandomPosition()

        -- Re-roll until we get a position that doesn't overlap an existing element
        while hasValue(positions, position) do
            position = getRandomPosition()
        end

        table.insert(positions, position)

        -- Snap to 30px grid
        if i==1 then
            elements[i] = Target(position[1] * 30, position[2] * 30)
        else
            elements[i] = Trap(position[1] * 30, position[2] * 30)
        end
    end

    -- Add sand and ice terrain (scales with level: 1 each at start, +1 every 2 levels)
    local terrainCount = 1 + math.floor(score / 2)
    local terrainTypes = {Sand, Ice}

    for t=1, #terrainTypes do
        for j=1, terrainCount do
            position = getRandomPosition()
            while hasValue(positions, position) do
                position = getRandomPosition()
            end
            table.insert(positions, position)
            local idx = #elements + 1
            elements[idx] = terrainTypes[t](position[1] * 30, position[2] * 30)
        end
    end
end

-- Checks if a table (used as a 2D position) already exists in a list
function hasValue (tab, val)
    for index, value in ipairs(tab) do
        if is_table_equal(value, val, false) then
            return true
        end
    end
    return false
end