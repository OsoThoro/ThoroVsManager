fx_version 'cerulean'
game 'gta5'

author 'Thorough'
description 'Vehicle Pack Scanner for ESX'
github 'https://github.com/OsoThoro/ThoroVsManager'

lua54 'yes'

shared_script 'config.lua'

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
    'config.lua'
}

dependencies {
    'oxmysql',
    'ox_lib'
}
