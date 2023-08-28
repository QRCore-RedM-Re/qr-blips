
fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
author 'RSK'
description 'Blips Management'
version '1.0.0'
lua54 'yes'


-- Client Scripts
client_scripts {
    '@ox_lib/init.lua',
    'client.lua', -- Assuming your main script's name is client.lua
}

-- Server Scripts
server_scripts {
    '@oxmysql/lib/MySQL.lua',  -- Include the MySQL-Async library
    'server.lua' -- Assuming you have a separate server script
}

exports {
    'addBlip',
    'removeBlip',
    'updateBlip',
}