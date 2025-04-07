-- Client-side logic for interacting with the vehicle data (if needed for additional functionality)

-- Example: Notify players when vehicle pack scanning is completed
RegisterNetEvent('vehiclePackScanner:notify')
AddEventHandler('vehiclePackScanner:notify', function(message)
    print(message)  -- You can use ox_lib's notify system instead for better UI feedback
end)
