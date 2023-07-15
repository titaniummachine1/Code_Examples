--using https://github.com/lnx00/Lmaobox-Library

-- Load lnxLib library
---@type boolean, lnxLib
local libLoaded, lnxLib = pcall(require, "lnxLib")
assert(libLoaded, "lnxLib not found, please install it!")
assert(lnxLib.GetVersion() <= 0.995, "lnxLib version is too old, please update it!")


-- Import required modules from lnxLib
local WPlayer = lnxLib.TF2.WPlayer
local Prediction = lnxLib.TF2.Prediction

local pLocalPath = {}

-- Callback function for CreateMove event
local function OnCreateMove()
    pLocal = entities.GetLocalPlayer()
    local WpLocal = WPlayer.FromEntity(pLocal) -- Convert pLocal to lualib WPlayer

    local predData = Prediction.Player(WpLocal, 15) -- Time (ticks), strafe angle (0 or nil = disabled)
    pLocalPath = predData.pos
end

-- Draw predicted path
local function doDraw()
    draw.Color(255, 255, 255, 255)

    -- Draw lines between the predicted positions
    if pLocalPath == nil then return end

    for i = 1, #pLocalPath - 1 do
        local pos1 = pLocalPath[i]
        local pos2 = pLocalPath[i + 1]

        local screenPos1 = client.WorldToScreen(pos1)
        local screenPos2 = client.WorldToScreen(pos2)

        if screenPos1 ~= nil and screenPos2 ~= nil then
            draw.Line(screenPos1[1], screenPos1[2], screenPos2[1], screenPos2[2])
        end
    end
end

-- Unregister previous callbacks
callbacks.Unregister("CreateMove", "MCT_CreateMove") -- Unregister the "CreateMove" callback
callbacks.Unregister("Draw", "MCT_Draw1") -- Unregister the "Draw" callback

-- Register callbacks
callbacks.Register("CreateMove", "MCT_CreateMove", OnCreateMove) -- Register the "CreateMove" callback
callbacks.Register("Draw", "MCT_Draw1", doDraw) -- Register the "Draw" callback
