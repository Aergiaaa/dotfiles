config.load_autoconfig()

config.set('colors.webpage.preferred_color_scheme', 'dark')   

c.fonts.default_family = 'JetBrains Mono'

c.fonts.default_size = '18px'

c.url.default_page = "about:blank"   

c.url.searchengines = {'DEFAULT': 'https://search.brave.com/search?q={}'}

config.bind('<Ctrl+=>', 'zoom-in')
config.bind('<Ctrl+->', 'zoom-out')
config.bind('<Ctrl+0>', 'config-source')

config.bind('<Ctrl+;>', 'config-cycle tabs.show always never')   

config.bind("<Ctrl+p>", 'config-cycle statusbar.show always never')

config.bind('<Ctrl+f>', 'hint all right-click')

config.set('hints.selectors', {
    **c.hints.selectors,
    'scrollable': ['.__qb_scrollable__'],
})
config.bind(';s', 'hint scrollable')   
config.bind(',m', 'hint links spawn mpv --ytdl-raw-options=cookies-from-browser=chromium:~/.local/share/qutebrowser/webengine,js-runtimes=node,remote-components=ejs:github {hint-url}')
config.bind(',M', 'hint links spawn mpv {hint-url}')
# config.bind(',y', 'hint links spawn yt-dlp {hint-url} -P ~/downloads/music --embed-metadata --embed-thumbnail --js-runtimes node --cookies-from-browser chromium:~/.local/share/qutebrowser/webengine --remote-components ejs:github')
config.bind(',y', 'hint links spawn yt-dlp {hint-url} -P ~/downloads/music --embed-metadata --embed-thumbnail --convert-thumbnails jpg -x --audio-format opus --audio-quality 0 --js-runtimes node ')
