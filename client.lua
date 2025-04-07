-- Client-side logic for interacting with the vehicle data

-- Client-side logic for handling notifications when vehicle scan is completed
RegisterNetEvent('vehiclePackScanner:notify')
AddEventHandler('vehiclePackScanner:notify', function(message)
    -- Using ox_lib's notify function to give feedback to the player
    exports['ox_lib']:notify({
        title = 'Vehicle Pack Scanner',
        message = message,
        type = 'success'  -- You can adjust this based on success or error
    })
end)


-- Example of sending a notification from the server side after scanning
-- This will notify the player that the scan has been completed
TriggerServerEvent('vehiclePackScanner:notify', 'Vehicle pack scanning completed successfully!')


