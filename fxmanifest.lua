fx_version 'bodacious'
game 'gta5'
version '1.4'

dependency 'NativeUI'

client_script '@NativeUI/NativeUI.lua'

client_scripts {
    'config.lua',
    'client/spawn.lua',
    'client/menu.lua',
    'client/airports.lua',
    'client/client.lua'
}

server_script {
    'config.lua',
    'server/server.lua'
}
