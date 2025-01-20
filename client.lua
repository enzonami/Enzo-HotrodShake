local QBCore = exports['qb-core']:GetCoreObject()
local wasEngineRunning = false

-- Export for Ox Inventory: Applies the Hotrod Tune on the client-side
exports('applyHotrodTune', function(data)
    local playerPed = PlayerPedId()
    local playerJob = QBCore.Functions.GetPlayerData().job.name -- Retrieve the player's job
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    -- Validate vehicle
    if not DoesEntityExist(vehicle) then
        TriggerEvent('ox_lib:notify', {
            title = 'Hotrod Tune',
            description = 'You are not in a valid vehicle!',
            type = 'error'
        })
        return false
    end

    -- Check job restrictions
    if Config.RestrictByJob and not Config.AllowedJobs[playerJob] then
        TriggerEvent('ox_lib:notify', {
            title = 'Hotrod Tune',
            description = 'Your job does not allow you to use this item!',
            type = 'error'
        })
        return false
    end

    -- Check vehicle model restrictions
    local model = GetEntityModel(vehicle)
    if Config.RestrictByVehicle and not Config.AllowedVehicles[model] then
        TriggerEvent('ox_lib:notify', {
            title = 'Hotrod Tune',
            description = 'This vehicle is not eligible for the Hotrod Tune!',
            type = 'error'
        })
        return false
    end

    -- Check if the vehicle is already tuned using its statebag
    local state = Entity(vehicle).state
    if state.isTuned then
        TriggerEvent('ox_lib:notify', {
            title = 'Hotrod Tune',
            description = 'This vehicle already has the Hotrod Tune!',
            type = 'error'
        })
        return false
    end

    -- Display a progress bar
    local completed = lib.progressBar({
        duration = 5000, -- 5 seconds
        label = 'Applying Hotrod Tune...',
        useWhileDead = false,
        canCancel = true
    })

    if not completed then
        TriggerEvent('ox_lib:notify', {
            title = 'Hotrod Tune',
            description = 'Tune application canceled!',
            type = 'error'
        })
        return false
    end

    -- Retrieve the plate
    local plate = data.metadata and data.metadata.plate or GetVehicleNumberPlateText(vehicle)

    -- Trigger the server to save the tune
    TriggerServerEvent('enzo-hotrodshake:saveHotrodTune', plate)

    return true
end)

-- Event to trigger the hotrod effect
RegisterNetEvent('enzo-hotrodshake:triggerHotrodEffect', function()
    ShakeGameplayCam("SKY_DIVING_SHAKE", Config.ShakeIntensity)
    Wait(Config.ShakeDuration)
    StopGameplayCamShaking(true)
end)

-- Monitor vehicle entry and engine state
lib.onCache('vehicle', function(vehicle)
    if vehicle then
        -- Check the vehicle's statebag for the tuned status
        local state = Entity(vehicle).state
        if state.isTuned then
            -- Monitor engine state
            Citizen.CreateThread(function()
                wasEngineRunning = GetIsVehicleEngineRunning(vehicle)

                while IsPedInAnyVehicle(PlayerPedId(), false) do
                    Wait(500) -- Check every 250ms
                    local isEngineRunning = GetIsVehicleEngineRunning(vehicle)

                    if isEngineRunning and not wasEngineRunning then
                        TriggerEvent('enzo-hotrodshake:triggerHotrodEffect')
                        wasEngineRunning = true
                    elseif not isEngineRunning then
                        wasEngineRunning = false
                    end
                end
            end)
        end
    else
        -- Reset state when exiting a vehicle
        wasEngineRunning = false
    end
end)
