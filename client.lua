local QRCore = exports['qr-core']:GetCoreObject()
local blipsLoaded = {}
local blipHandles = {}

-- Load and display blips from server
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)

        QRCore.Functions.TriggerCallback('getBlips', function(blips)
            for _, blip in pairs(blipsLoaded) do
                RemoveBlip(blip)
            end
            
            blipHandles = {}
            local hour = GetClockHours()

            for _, info in pairs(blips) do
                local currentColor = (hour >= info.openTime and hour < info.closeTime) and info.openColor or info.closeColor

                local blipId = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, info.position.x, info.position.y, info.position.z)
                SetBlipSprite(blipId, info.sprite, 1)
                Citizen.InvokeNative(0x662D364ABF16DE2F, blipId, GetHashKey(currentColor))

                local varString = CreateVarString(10, 'LITERAL_STRING', info.name)
                Citizen.InvokeNative(0x9CB1A1623062F402, blipId, varString)
                
                table.insert(blipsLoaded, blipId)
                blipHandles[info.name] = blipId
            end
        end)
    end
end)

-- Menu to Add and Remove Blips
local blipMenu = {
    id = 'blip_manager',
    title = 'Blips Management',
    options = {
        {
            title = 'Add Blips',
            onSelect = function()
                local input = lib.inputDialog('Blips Management', {
                    {type = 'input', label = 'Blip Name', required = true},
                    {type = 'number', label = 'Sprite ID',required = true},
                    {type = 'input', label = 'Position (format: x,y,z)', pattern = "^-?\\d+\\.?\\d*,\\s?-?\\d+\\.?\\d*,\\s?-?\\d+\\.?\\d*$", required = true},
                    {type = 'number', label = 'Open Time (0-24)', min = 0, max = 24},
                    {type = 'number', label = 'Close Time (0-24)', min = 0, max = 24},
                    {type = 'input', label = 'Color when open', default = 'BLIP_MODIFIER_MP_COLOR_1'},
                    {type = 'input', label = 'Color when closed', default = 'BLIP_MODIFIER_MP_COLOR_2'}
                })

                if input then
                    local coords = stringsplit(input[3], ",")
                    local blipData = {
                        name = input[1],
                        sprite = tonumber(input[2]),
                        position = vector3(tonumber(coords[1]), tonumber(coords[2]), tonumber(coords[3])),
                        openTime = tonumber(input[4]),
                        closeTime = tonumber(input[5]),
                        openColor = input[6],
                        closeColor = input[7]
                    }

                    QRCore.Functions.TriggerCallback('addBlip', function(success)
                        if success then
                            addBlipToMap(blipData)
                            print("Blip added successfully!")
                        else
                            print("Failed to add blip!")
                        end
                    end, blipData)
                end
            end
        },
        {
            title = 'Remove Blip',
            onSelect = function()
                QRCore.Functions.TriggerCallback('getBlips', function(blips)
                    local blipOptions = {}
                    for _, blip in pairs(blips) do
                        table.insert(blipOptions, {
                            title = blip.name,
                            onSelect = function()
                                QRCore.Functions.TriggerCallback('removeBlip', function(success)
                                    if success then
                                        removeBlipByName(blip.name)
                                        print("Blip removed successfully!")
                                    else
                                        print("Failed to remove blip!")
                                    end
                                end, blip.name)
                            end
                        })
                    end

                    lib.registerContext({
                        id = 'remove_blip_menu',
                        title = 'Select Blip to Remove',
                        options = blipOptions
                    })
                    lib.showContext('remove_blip_menu')
                end)
            end
        }
    }
}


lib.registerContext(blipMenu)


-- Command to open the blip management menu
RegisterCommand("blipmenu", function()
    lib.showContext('blip_manager')
end, false)

-- Add a single blip to the map
function addBlipToMap(blipData)
    local hour = GetClockHours()
    local currentColor = (hour >= blipData.openTime and hour < blipData.closeTime) and blipData.openColor or blipData.closeColor

    local blipId = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, blipData.position.x, blipData.position.y, blipData.position.z)
    SetBlipSprite(blipId, blipData.sprite, 1)
    Citizen.InvokeNative(0x662D364ABF16DE2F, blipId, GetHashKey(currentColor))

    local varString = CreateVarString(10, 'LITERAL_STRING', blipData.name)
    Citizen.InvokeNative(0x9CB1A1623062F402, blipId, varString)
    
    table.insert(blipsLoaded, blipId)
    blipHandles[blipData.name] = blipId
end

-- Remove a single blip from the map by its name
function removeBlipByName(blipName)
    local blipId = blipHandles[blipName]
    if blipId then
        RemoveBlip(blipId)
        blipHandles[blipName] = nil

        for i=#blipsLoaded, 1, -1 do
            if blipsLoaded[i] == blipId then
                table.remove(blipsLoaded, i)
                break
            end
        end
    end
end

-- Helper function to split strings
function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

-- Exports

exports('addBlip', function(blipData)
    addBlipToMap(blipData)
end)

exports('removeBlip', function(blipName)
    removeBlipByName(blipName)
end)

exports('getAllBlips', function()
    return blipsLoaded
end)
