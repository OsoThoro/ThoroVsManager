local MySQL = exports.oxmysql  -- Ensure oxmysql is being used correctly

-- Load the config
Config = require('config')

-- Function to scan all configured vehicle packs
local function scanAllVehiclePacks()
    -- Loop through all configured vehicle packs and scan each one
    for _, vehiclePack in ipairs(Config.VehiclePacks) do
        local resourceName = vehiclePack.resourceName
        local resourceLocation = vehiclePack.resourceLocation

        -- Trigger the scan for each vehicle pack (use the scanVehiclePack function from earlier)
        print("Starting scan for vehicle pack: " .. resourceName)

        -- Trigger the scanning process
        scanVehiclePack(resourceName)

        -- Optionally, print out or log the location of the vehicle pack
        print("Scanning location: " .. resourceLocation)
    end
end

-- Automatically scan the vehicle packs if enabled in the config
if Config.EnableScanOnStart then
    Citizen.CreateThread(function()
        scanAllVehiclePacks()
    end)
end

-- Register the /scanvehicles command (manual trigger)
RegisterCommand('scanvehicles', function(source, args, rawCommand)
    -- Check if the player has permission (optional, only allow admins to run this command)
    local player = source
    if IsPlayerAceAllowed(player, "admin") then
        -- Notify the player that the scan has started
        TriggerClientEvent('chat:addMessage', player, {
            args = { '^2[Vehicle Scanner]', 'Scanning vehicle pack. Please wait...' }
        })
        
        -- Trigger the scanAllVehiclePacks function
        Citizen.CreateThread(function()
            scanAllVehiclePacks()

            -- Notify the player when the scan is complete
            TriggerClientEvent('chat:addMessage', player, {
                args = { '^2[Vehicle Scanner]', 'Vehicle scan complete!' }
            })
        end)
    else
        -- Notify the player they don't have permission
        TriggerClientEvent('chat:addMessage', player, {
            args = { '^1[Vehicle Scanner]', 'You do not have permission to run this command.' }
        })
    end
end, false)


-- Utility function to capitalize strings (for category labels, etc.)
function string:capitalize()
    return (self:gsub("^%l", string.upper))
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


-- Function to scan the resource directory and get a list of .meta files
function getMetaFiles(path)
    local files = {}
    
    -- Attempt to read the directory contents (this requires a method to read files, let's use fs for simplicity)
    local resourceFolder = path
    local directory = GetDirFiles(resourceFolder)  -- Assuming GetDirFiles can list files in a resource

    for _, file in ipairs(directory) do
        -- Only add .meta files to our list
        if file:match("%.meta$") then
            table.insert(files, file)
        end
    end

    return files
end


-- Function to extract vehicle data from a .meta file
function extractVehicleData(file)
    -- Placeholder example for parsing a file, assuming it's in a readable format
    local vehicle = {}

    -- You could use a specific Lua XML parser if the .meta files are XML or JSON parsers if it's JSON
    -- For this example, let's pretend the .meta file is a simple Lua table-like structure

    -- Open the file and read its content (this will need to adapt based on your actual file format)
    local content = LoadResourceFile("your_resource", file)  -- Load the file contents from the resource folder

    if content then
        -- Parse the content (simple example assuming Lua format)
        local vehicleData = load("return " .. content)()

        -- Populate vehicle details
        vehicle.name = vehicleData.name or "Unknown"
        vehicle.model = vehicleData.model or "Unknown"
        vehicle.category = vehicleData.category or "misc"  -- Default to 'misc' if no category
        vehicle.price = vehicleData.price  -- We can set this later if needed

        -- Generate a random price if it's missing
        if not vehicle.price then
            vehicle.price = math.random(Config.PriceRange.min, Config.PriceRange.max)
        end
    end

    return vehicle
end


-- Function to check if vehicle already exists in the database and insert if not
function checkIfVehicleExists(vehicle)
    MySQL.query('SELECT * FROM vehicles WHERE model = ?', { vehicle.model }, function(result)
        if #result == 0 then
            -- If the vehicle doesn't exist, insert the category and the vehicle
            insertVehicleCategory(vehicle.category)
            insertVehicleData(vehicle)
        else
            print("Vehicle already exists: " .. vehicle.model)
        end
    end)
end


-- Function to insert vehicle category into `vehicle_categories`
function insertVehicleCategory(category)
    MySQL.query('SELECT * FROM vehicle_categories WHERE name = ?', { category }, function(result)
        if #result == 0 then
            -- Insert category if it doesn't exist
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
