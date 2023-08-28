local QRCore = exports['qr-core']:GetCoreObject()

-- Fetch all blips
QRCore.Functions.CreateCallback('getBlips', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM blips', {}, function(result)
        local blips = {}
        for i=1, #result, 1 do
            table.insert(blips, {
                name = result[i].name,
                sprite = result[i].sprite,
                position = json.decode(result[i].position),
                openTime = result[i].openTime,
                closeTime = result[i].closeTime,
                openColor = result[i].openColor,
                closeColor = result[i].closeColor
            })
        end
        cb(blips)
    end)
end)

-- Add New Blip
QRCore.Functions.CreateCallback('addBlip', function(source, cb, blipData)
    MySQL.Async.fetchScalar('SELECT COUNT(*) FROM blips WHERE name = @name', {
        ['@name'] = blipData.name
    }, function(count)
        if count > 0 then
            cb(false, "A blip with the same name already exists!")
            return
        end

        MySQL.Async.insert('INSERT INTO blips (name, sprite, position, openTime, closeTime, openColor, closeColor) VALUES (@name, @sprite, @position, @openTime, @closeTime, @openColor, @closeColor)', {
            ['@name'] = blipData.name,
            ['@sprite'] = blipData.sprite,
            ['@position'] = json.encode(blipData.position),
            ['@openTime'] = blipData.openTime,
            ['@closeTime'] = blipData.closeTime,
            ['@openColor'] = blipData.openColor,
            ['@closeColor'] = blipData.closeColor
        }, function(insertId)
            if insertId then
                cb(true)
            else
                cb(false, "Failed to add blip to the database.")
            end
        end)
    end)
end)

--Remove Blip

QRCore.Functions.CreateCallback('removeBlip', function(source, cb, blipName)
    MySQL.Async.execute('DELETE FROM blips WHERE name = @name', {
        ['@name'] = blipName
    }, function(rowsChanged)
        if rowsChanged > 0 then
            cb(true)
        else
            cb(false, "Failed to remove blip from the database.")
        end
    end)
end)

