> # WORK IN PROGRESS

# Vehicle Pack Scanner for ESX

## Description
This resource scans vehicle packs for metadata and imports vehicle data into the `vehicles` and `vehicle_categories` tables of your database. If prices are missing, they are generated automatically based on configurable ranges.

## Features
- Scans vehicle packs for `.meta` files and extracts vehicle data.
- Imports vehicle data into the `vehicles` and `vehicle_categories` tables.
- Automatically generates prices for vehicles if missing.
- Configurable options for price range and whether to generate missing prices.

## Configuration
You can configure the resource by editing the `config.lua` file. The following options are available:
- `Config.GeneratePricesIfMissing` - Set to `true` to generate random prices if missing.
- `Config.PriceRange` - Defines the range of random prices to generate.
- `Config.VehiclePackPath` - Path to the vehicle pack folder.

## Installation
1. Place the `ThoroVsManager` folder in your `resources` folder.
2. Add `start ThoroVsManager` to your `server.cfg`.
3. Configure the `config.lua` file.
4. Ensure `oxmysql` is installed for database support.

## Future Updates
- Support for scanning additional vehicle data (engine specs, colors, etc.).
