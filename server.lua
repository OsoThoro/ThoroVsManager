-- Server-side logic for scanning vehicle packs and importing data into the database

local MySQL = require('oxmysql')  -- Using oxmysql

-- Function to scan a vehicle pack resource for .meta files
function scanVehiclePack(resourceName)
    local vehicles = {}

    -- Get the resource folder path (configurable in config.lua)
    local resourcePath = Config.VehiclePackPath .. resourceName .. '/stream/'

    -- Example of scanning .meta files in the resource folder (customize as needed)
    local metaFiles = getMetaFiles(resourcePath)  -- This function needs to be implemented

    for _, file in ipairs(metaFiles) do
        local vehicle = extractVehicleData(file)  -- Custom function to parse .meta files
        if vehicle then
            -- Generate a random price if not provided
            if not vehicle.price and Config.GeneratePricesIfMissing then
                vehicle.price = math.random(Config.PriceRange.min, Config.PriceRange.max)
            end

            -- Insert vehicle category if not already in the database
            insertVehicleCategory(vehicle.category)

            -- Insert vehicle data into the database
            insertVehicleData(vehicle)
        end
    end
end

-- Function to insert a vehicle into the `vehicle_categories` table
function insertVehicleCategory(category)
    MySQL.query('SELECT * FROM vehicle_categories WHERE name = ?', { category }, function(result)
        if #result == 0 then
            MySQL.query('INSERT INTO vehicle_categories (name, label) VALUES (?, ?)', { category, category:capitalize() })
        end
    end)
end

-- Function to insert vehicle data into the `vehicles` table
function insertVehicleData(vehicle)
    MySQL.query('INSERT INTO vehicles (name, model, price, category) VALUES (?, ?, ?, ?)', {
        vehicle.name, vehicle.model, vehicle.price, vehicle.category
    })
end

-- Function to extract vehicle data from a .meta file
function extractVehicleData(file)
    -- Parsing logic to extract vehicle name, model, category, and price
    -- You may need to adjust this depending on the structure of the .meta files

    local vehicle = {}
    vehicle.name = file.name or "Unknown"
    vehicle.model = file.model or "Unknown"
    vehicle.category = file.category or "misc"  -- Default category if not specified
    vehicle.price = file.price  -- Price might be undefined, will generate if missing

    return vehicle
end
