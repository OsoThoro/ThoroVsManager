-- Configuration file for Vehicle Pack Scanner

Config = {}

-- Whether or not to automatically generate vehicle prices if they are missing
Config.GeneratePricesIfMissing = true

-- Range for random price generation (low, high)
Config.PriceRange = { min = 50000, max = 200000 }

-- Path to the vehiclse pack folder
Config.VehiclePacks = {
    {
        resourceName = "vehicles_pack_1", -- Replace with your actual resource name
        resourceLocation = "resources/vehicles_pack_1" -- Adjust the location as needed
    },
    {
        resourceName = "vehicles_pack_2", -- Another resource pack
        resourceLocation = "resources/vehicles_pack_2"
    }
}

-- Whether to automatically start scanning on script start
Config.EnableScanOnStart = true 
