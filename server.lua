local MySQL = require('oxmysql')

-- Scan the resource folder for vehicle packs
function scanVehiclePackResource(resourcePath)
    local vehicleCategoryMappings = {
        ['compacts'] = 'Compacts',
        ['coupes'] = 'Coupés',
        ['sedans'] = 'Sedans',
        ['sports'] = 'Sports',
        ['sportsclassics'] = 'Sports Classics',
        ['super'] = 'Super',
        ['muscle'] = 'Muscle',
        ['offroad'] = 'Off Road',
        ['suvs'] = 'SUVs',
        ['vans'] = 'Vans',
        ['motorcycles'] = 'Motos'
    }

    local vehicles = {}

    -- Scan the stream and meta files within the resource
    local metaFiles = GetMetaFiles(resourcePath) -- A function that will fetch all the meta files
    for _, metaFile in ipairs(metaFiles) do
        local vehicleData = ParseVehicleMetaFile(metaFile) -- Function that parses the meta file

        if vehicleData then
            -- Default category if not found
            local category = vehicleCategoryMappings[vehicleData.category] or 'Other'
            local price = vehicleData.price or GenerateRandomPrice(category)

            -- Prepare the data for insertion
            table.insert(vehicles, {
                name = vehicleData.name,
                model = vehicleData.model,
                price = price,
                category = category
            })
        end
    end

    return vehicles
end

-- Function to fetch all meta files in a directory
function GetMetaFiles(directory)
    -- Implement file scanning logic here
    -- For example, using a glob pattern to find all .meta files
    return {}
end

-- Function to parse vehicle meta file and extract data
function ParseVehicleMetaFile(filePath)
    -- Implement logic for parsing XML meta files to extract vehicle data
    -- Example: Extract model, name, category, and price
    return {
        name = 'ExampleVehicle',
        model = 'example_model',
        category = 'sports',  -- For instance
        price = nil  -- Assuming price is not provided
    }
end

-- Generate a random but realistic price based on category
function GenerateRandomPrice(category)
    local priceRange = Config.VehiclePriceRange[category]
    if priceRange then
        return math.random(priceRange.min, priceRange.max)
    else
        return math.random(15000, 50000) -- Default price range
    end
end

-- Insert vehicles into the database
function InsertVehiclesToDatabase(vehicles)
    for _, vehicle in ipairs(vehicles) do
        local query = string.format(
            "INSERT INTO vehicles (name, model, price, category) VALUES ('%s', '%s', %d, '%s')",
            vehicle.name, vehicle.model, vehicle.price, vehicle.category
        )
        
        -- Execute MySQL query (using oxmysql)
        MySQL.query(query)
    end
end

-- Example function that runs when the resource starts
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local vehicles = scanVehiclePackResource('resources/vehicles') -- Provide the actual path
        InsertVehiclesToDatabase(vehicles)
    end
end)
