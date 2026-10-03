local ESX = nil
local doors = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM doors', {}, function(result)
        doors = result
        TriggerClientEvent('doors:updateDoors', -1, doors)
    end)
end)

ESX.RegisterServerCallback('doors:getDoors', function(source, cb)
    cb(doors)
end)

RegisterServerEvent('doors:toggleLock')
AddEventHandler('doors:toggleLock', function(doorId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local door = nil

    for _, d in ipairs(doors) do
        if d.id == doorId then
            door = d
            break
        end
    end

    if door then
        if xPlayer.job.name == 'police' or xPlayer.identifier == door.owner then
            door.locked = not door.locked
            MySQL.Async.execute('UPDATE doors SET locked = @locked WHERE id = @id', {
                ['@locked'] = door.locked,
                ['@id'] = door.id
            }, function()
                TriggerClientEvent('doors:updateDoors', -1, doors)
            end)
        else
            xPlayer.showNotification('You do not have permission to lock/unlock this door.')
        end
    end
end)

ESX.RegisterServerCallback('doors:buyDoor', function(source, cb, doorId, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local door = nil

    for _, d in ipairs(doors) do
        if d.id == doorId then
            door = d
            break
        end
    end

    if door then
        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price)
            door.owner = xPlayer.identifier
            MySQL.Async.execute('UPDATE doors SET owner = @owner WHERE id = @id', {
                ['@owner'] = door.owner,
                ['@id'] = door.id
            }, function()
                TriggerClientEvent('doors:updateDoors', -1, doors)
                cb(true)
            end)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)