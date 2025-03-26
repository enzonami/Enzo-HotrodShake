fx_version 'cerulean'
game 'gta5'

author 'Xviscerated'
description 'ShakeTune camera effects via custom tuning items.'
version '1.0.0'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',       -- Ox Lib initialization
    'config.lua'              -- Shared configuration
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- MySQL integration
    'server.lua'              -- Server logic
}

client_scripts {
    'client.lua'              -- Client logic
}

exports {
    'applyShakeTune'          -- Client export for Ox Inventory
}

dependencies {
    'ox_lib',                 -- Required for utility functions
    'oxmysql',                -- Required for database interaction
    'qb-core',                -- Framework dependency
    'ox_inventory'            -- Required for item handling
}