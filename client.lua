local ESX = nil
local PlayerData = {}
local doors = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, door in ipairs(doors) do
            local doorCoords = json.decode(door.coords)
            local distance = #(playerCoords - vector3(doorCoords.x, doorCoords.y, doorCoords.z))

            if distance < Config.InteractionDistance then
                DrawText3D(doorCoords.x, doorCoords.y, doorCoords.z, "~g~[E]~w~ " .. (door.locked and "Unlock" or "Lock") .. " Door")

                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent('doors:toggleLock', door.id)
                end
            end
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

RegisterNetEvent('doors:updateDoors')
AddEventHandler('doors:updateDoors', function(newDoors)
    doors = newDoors
end)