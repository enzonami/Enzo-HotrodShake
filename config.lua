Config = {}

-- Duration of the shaky camera effect (in milliseconds)
Config.ShakeDuration = 1000

-- Intensity of the shaky camera effect (higher = more intense)
Config.ShakeIntensity = 0.5

-- Toggle to enable/disable job restrictions
Config.RestrictByJob = true

-- Jobs allowed to use the ShakeTune
Config.AllowedJobs = {
    ["mechanic"] = true,
    ["tuner"] = true
}

-- Toggle to enable/disable vehicle model restrictions
Config.RestrictByVehicle = true

-- Vehicle models (hashes) allowed to use the ShakeTune
Config.AllowedVehicles = {
    [GetHashKey("dominator")] = true,
    [GetHashKey("buffalo")] = true
}