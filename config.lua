Config = {}

-- Duration of the shaky camera effect (in milliseconds)
Config.ShakeDuration = 1000

-- Intensity of the shaky camera effect (higher = more intense)
Config.ShakeIntensity = 0.5

-- Toggle to enable/disable job restrictions
Config.RestrictByJob = true -- Set to false to disable job-based restrictions

-- Jobs allowed to use the Hotrod Tune
Config.AllowedJobs = {
    ["mechanic"] = true,
    ["tuner"] = true -- Add more jobs as needed
}

-- Toggle to enable/disable vehicle model restrictions
Config.RestrictByVehicle = true -- Set to false to disable vehicle-based restrictions

-- Vehicle models (hashes) allowed to use the Hotrod Tune
Config.AllowedVehicles = {
    [GetHashKey("dominator")] = true, -- Example vehicle model
    [GetHashKey("buffalo")] = true -- Add more vehicle hashes as needed
}
