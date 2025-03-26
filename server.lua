local QBCore = exports['qb-core']:GetCoreObject()

-- Reload all vehicles with the Shake Tune into statebags when the resource starts
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        reloadShakeTuneStatebags()
    end
end)

-- Function to reload statebags
function reloadShakeTuneStatebags()
    MySQL.Async.fetchAll('SELECT plate FROM xVis_Shake_Tune', {}, function(results)
        for _, row in ipairs(results) do
            local vehicle = GetVehicleByPlate(row.plate)
            if vehicle then
                Entity(vehicle).state:set('isTuned', true, true)
            end
        end
    end)
end

-- Find the vehicle entity by its plate
function GetVehicleByPlate(plate)
    local vehicles = GetAllVehicles()
    for _, vehicle in ipairs(vehicles) do
        local vehiclePlate = GetVehicleNumberPlateText(vehicle)
        if vehiclePlate and string.lower(vehiclePlate) == string.lower(plate) then
            return vehicle
        end
    end
    return nil
end

-- Event to save a vehicle's plate to the database and set statebag
RegisterNetEvent('xVis_Shake_Tune:saveShakeTune', function(plate)
    local src = source

    -- Save the tune to the database
    MySQL.Async.execute('INSERT INTO xVis_Shake_Tune (plate) VALUES (@plate)', { ['@plate'] = plate }, function(affectedRows)
        if affectedRows > 0 then
            -- Find the vehicle and update its statebag
            local vehicle = GetVehicleByPlate(plate)
            if vehicle then
                Entity(vehicle).state:set('isTuned', true, true)
            end

            -- Trigger success notification
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Shake Tune',
                description = 'Shake Tune applied to this vehicle!',
                type = 'success'
            })
        else
            -- Trigger error notification
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Shake Tune',
                description = 'Failed to apply Shake Tune!',
                type = 'error'
            })
        end
    end)
end)
