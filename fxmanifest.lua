game 'rdr3'
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

ui_page "html/index.html"

shared_scripts {
    '@qbr-core/shared/locale.lua',
    'locale/en.lua'
}

client_scripts {
    'client/main.lua'
} 

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

files {
    "html/index.html",
    "html/styles.css",
    "html/eden.png",
    "html/telegram.png",
    "html/telegram_background.png",
    "html/telegram_divider.png",
    "html/telegram_footer.png",
    "html/telegram_header.png",
    "html/reset.css",
    "html/listener.js"
}
