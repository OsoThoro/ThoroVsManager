local MySQL = exports.oxmysql  -- Ensure oxmysql is being used correctly

-- Function to scan a vehicle pack resource for .meta files
function scanVehiclePack(resourceName)
    local vehicles = {}

    -- Get the resource folder path
    local resourcePath = Config.VehiclePackPath .. resourceName .. '/stream/'

    -- Example of scanning .meta files (this part can be customized based on your file structure)
    local metaFiles = getMetaFiles(resourcePath)  -- Function that gets the list of meta files in the resource

    for _, file in ipairs(metaFiles) do
        local vehicle = extractVehicleData(file)  -- Custom function to parse .meta files
        if vehicle then
            -- Check if vehicle already exists in the database
            checkIfVehicleExists(vehicle)
        end
    end
end

-- Function to check if the vehicle already exists in the database
function checkIfVehicleExists(vehicle)
    MySQL.query('SELECT * FROM vehicles WHERE model = ?', { vehicle.model }, function(result)
        if #result == 0 then
            -- Insert vehicle category if not already in the database
            insertVehicleCategory(vehicle.category)

            -- Insert vehicle data into the vehicles table
            insertVehicleData(vehicle)
        else
            print("Vehicle already exists: " .. vehicle.model)
        end
    end)
end

-- Function to insert vehicle category into the `vehicle_categories` table
function insertVehicleCategory(category)
    MySQL.query('SELECT * FROM vehicle_categories WHERE name = ?', { category }, function(result)
        if #result == 0 then
            -- Insert the category if it doesn't exist
            MySQL.query('INSERT INTO vehicle_categories (name, label) VALUES (?, ?)', { category, category:capitalize() })
            print("Inserted new category: " .. category)
        end
    end)
end

-- Function to insert vehicle data into the `vehicles` table
function insertVehicleData(vehicle)
    MySQL.query('INSERT INTO vehicles (name, model, price, category) VALUES (?, ?, ?, ?)', {
        vehicle.name, vehicle.model, vehicle.price, vehicle.category
    }, function(affectedRows)
        if affectedRows > 0 then
            print("Inserted new vehicle: " .. vehicle.name)
        else
            print("Failed to insert vehicle: " .. vehicle.name)
        end
    end)
end

-- Function to extract vehicle data from a .meta file
function extractVehicleData(file)
    -- Parsing logic to extract vehicle name, model, category, and price
    -- This is where you would parse the .meta file contents. Here's a simplified example:

    local vehicle = {}
    vehicle.name = file.name or "Unknown"
    vehicle.model = file.model or "Unknown"
    vehicle.category = file.category or "misc"  -- Default category if not specified
    vehicle.price = file.price  -- Price might be undefined, will generate if missing

    -- Generate random price if it's missing
    if not vehicle.price then
        vehicle.price = math.random(Config.PriceRange.min, Config.PriceRange.max)
    end

    return vehicle
end

-- Helper function to get .meta files in the vehicle pack (custom implementation)
function getMetaFiles(path)
    -- Custom logic to scan the directory and return a list of meta files
    -- This could be achieved through the file system API or any specific method you're using to get files in a resource

    return {}  -- Example return; this needs to scan and return actual file paths or file objects
end
