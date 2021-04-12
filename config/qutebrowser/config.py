import dracula.draw

# Load existing settings made via :set
config.load_autoconfig()

dracula.draw.blood(c, {'spacing': {'vertical': 6, 'horizontal': 8}})
c.tabs.position = "bottom"
c.url.start_pages = ["https://start.duckduckgo.com"]
c.url.default_page = "https://start.duckduckgo.com"
c.editor.command = [
    '/usr/bin/nvim', '-f', '{file}', '-c', 'normal {line}G{column0}l'
]

config.bind('<z><l>', 'spawn --userscript qute-pass')
config.bind('<z><u><l>', 'spawn --userscript qute-pass --username-only')
config.bind('<z><p><l>', 'spawn --userscript qute-pass --password-only')
config.bind('<z><o><l>', 'spawn --userscript qute-pass --otp-only')

# Dark mode
# config.set("colors.webpage.darkmode.enabled", True)

c.url.searchengines = {
    "DEFAULT": "https://www.duckduckgo.com/?q={}",
    "sx": "https://search.disroot.org/?q={}",
    "g": "https://www.google.com/search?q={}",
    "ddg": "https://www.duckduckgo.com/?q={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "ytm": "https://music.youtube.com/search?q={}",
    "aw": "https://wiki.archlinux.org/?search={}",
    "aur": "https://aur.archlinux.org/packages/?K={}",
}
