resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'
resource_version '1.3'

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