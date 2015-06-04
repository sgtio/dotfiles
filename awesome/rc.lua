-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
require("awful.dbus")
require("awful.remote")
awful.ewmh = require("awful.ewmh")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Extra Layouts
local lain = require("lain")
-- Vicious widgets
local vicious = require("vicious")
-- Weather library
local weather = require("modules/weather")
-- Utilities and System default definition
local tools = {
    terminal = "urxvtc",
    system = {
        filemanager = "thunar",
    },
    browser = {
    },
    editor = {
    },
    email = "geary",
}

tools.browser.primary = os.getenv("BROWSER") or "firefox"
tools.browser.secondary = ({chromium="firefox", firefox="chromium"})[tools.browser.primary]
tools.editor.primary = os.getenv("EDITOR") or "emacs"
tools.editor.secondary = ({emacs="gvim", gvim="emacs"})[tools.editor.primary]

-- Paths
local paths = {}
paths.home = os.getenv("HOME") .. "/"
paths.dotfiles = paths.home .. ".config/dotfiles/"
paths.scripts = paths.dotfiles .. "scripts/"
paths.dunst = paths.dotfiles .. "dunst/"
paths.awesome = {
   default = paths.dotfiles .. "awesome/",
   themes = paths.dotfiles .. "awesome/themes/", 
}
-- customization
customization = {}
customization.config = {}
customization.orig = {}
customization.func = {}
customization.default = {}
customization.option = {}
customization.timer = {}

customization.config.version = "1.0.0"

customization.default.property = {
    layout = awful.layout.suit.floating,
    mwfact = 0.5,
    nmaster = 1,
    ncol = 1,
    min_opacity = 0.4,
    max_opacity = 1,
    default_naughty_opacity = 1,
}

customization.default.compmgr = 'compton'

naughty.config.presets.low.opacity = customization.default.property.default_naughty_opacity
naughty.config.presets.normal.opacity = customization.default.property.default_naughty_opacity
naughty.config.presets.critical.opacity = customization.default.property.default_naughty_opacity

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(paths.awesome.themes .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc -e bash -c 'tmux -q has-session && exec tmux attach-session -d || exec tmux new-session -n$USER -s$USER@$HOSTNAME'"
editor = os.getenv("EDITOR") or "emacs"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,           -- 1
    awful.layout.suit.tile,               -- 2
    --awful.layout.suit.tile.left,        -- 3
    --awful.layout.suit.tile.bottom,      -- 4
    --awful.layout.suit.tile.top,         -- 5
    --awful.layout.suit.fair,             -- 6
    --awful.layout.suit.fair.horizontal,  -- 7
    --awful.layout.suit.spiral,           -- 8
    --awful.layout.suit.spiral.dwindle,   -- 9
    awful.layout.suit.max,                -- 10
    --awful.layout.suit.max.fullscreen,   -- 11
    --awful.layout.suit.magnifier,        -- 12
    lain.layout.uselessfair,              -- 13
    lain.layout.uselesstile,              -- 14
    lain.layout.uselesspiral,             -- 15
}
-- }}}


-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.fit(beautiful.wallpaper, s, "#3c352f")
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
   names  = {
      ':Web',
      '>_:Term',
      ':IDE',
      ':Files',
      '⌘:Office',
      '✉:Mail',
      '♫:Multimedia',
      '✣:Floating',
      ':External',
   },
   layout = {
      layouts[2],   -- 1:Web
      layouts[2],  -- 2:Term
      layouts[2],  -- 3:IDE
      layouts[2],  -- 4:Files
      layouts[2],  -- 5:Office
      layouts[2],  -- 6:Mail
      layouts[2],  -- 7:Multimedia
      layouts[1],   -- 8:Float
      layouts[2],  -- 9:External
   }
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "Awesome", myawesomemenu, beautiful.arch_icon },
			     { "Open Terminal", terminal },
			     { "Log Out" , function () awful.util.spawn(paths.scripts .. "haltdialog.sh") end},
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.arch_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Vicious

-- Separator definition
local separator = '<span color="' .. beautiful.separator .. '"></span>'

-- RAM widget
memwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.mem)
vicious.register(memwidget, vicious.widgets.mem,
		 function(widget, args)
		    memtext = ''
		    if args[1] < 40 then
		       memtext = string.format('<span color="%s"> : %d%% </span>',
					    beautiful.green, args[1])
		    elseif args[1] < 70 then
		       memtext = string.format('<span color="%s"> : %d%% </span>', beautiful.yellow, args[1])
		    else
		       memtext = string.format('<span color="%s"> : %d%% </span>', beautiful.red, args[1])
		    end
		    return separator .. memtext .. separator
		 end,
		 13)	    

-- CPU usage
cputextwidget = wibox.widget.textbox()
cpuwidget = awful.widget.graph()
cpuwidget:set_width(50)
cpuwidget:set_background_color("#4f5b67")
cpuwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 25 },
			  stops = { { 0, "" .. beautiful.red .. ""},
			     { 0.5, "" .. beautiful.yellow .. "" },
			     { 1, "" .. beautiful.green .. "" }
}})

vicious.cache(vicious.widgets.cpu)
vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 3)
vicious.register(cputextwidget, vicious.widgets.cpu,
		 function(widget, args)
		    cputext = ''
		    if args[1] < 33 then
		       cputext = string.format('<span color="%s"> : %d%% </span>', beautiful.green, args[1])
		    elseif args[1] < 66 then
		       cputext = string.format('<span color="%s"> : %d%% </span>', beautiful.yellow, args[1])
		    else
		       cputext = string.format('<span color="%s"> : %d%% </span>', beautiful.red, args[1])
		    end
		    return separator .. cputext
		 end,
		 3)
-- Disk Usage
iowidget = wibox.widget.textbox()
iographwidget = awful.widget.graph()
iographwidget:set_max_value(225)
iographwidget:set_width(50)
iographwidget:set_background_color("" .. beautiful.bg_graph .. "")
iographwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 25 },
			  stops = { { 0, "" .. beautiful.red .. ""},
			     { 0.5, "" .. beautiful.yellow .. "" },
			     { 1, "" .. beautiful.green .. "" }
}})

vicious.cache(vicious.widgets.dio)
vicious.register(iowidget, vicious.widgets.dio,
		 function(widget, args)
		    disktext = ''
		    if tonumber(args["{sda total_mb}"]) < 3 then
		       disktext = string.format('<span color="%s"> : %sMB </span>', beautiful.green, args["{sda total_mb}"])
		    elseif tonumber(args["{sda total_mb}"]) < 10 then
		       disktext =  string.format('<span color="%s"> : %sMB </span>', beautiful.yellow, args["{sda total_mb}"])
		    else
		       disktext =  string.format('<span color="%s"> : %sMB </span>', beautiful.red, args["{sda total_mb}"])
		    end
		    return separator .. disktext
		 end,
		 3)
vicious.register(iographwidget, vicious.widgets.dio, "${sda total_kb}", 3)

-- CPU Temperature
cputempwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.thermal)
vicious.register(cputempwidget, vicious.widgets.thermal,
		 function(widget, args)
		    temptext = ''
		    if args[1] < 50 then
		       temptext =  string.format('<span color="%s"> : %dCº </span>', beautiful.green, args[1])
		    elseif args[1] < 75 then
		       temptext = string.format('<span color="%s"> : %dCº </span>', beautiful.yellow, args[1])
		    else
		       temptext = string.format('<span color="%s"> : %dCº </span>', beautiful.red, args[1])
		    end
		    return temptext .. separator
		 end,
		 10, "thermal_zone0")

-- Music

-- Weather
weatherwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.weather)
vicious.register(weatherwidget, vicious.widgets.weather,
		 function(widget, args)
		    return weather.getWeather(paths)
		 end,
		 300, 'ESMS')

-- Mail

--}}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock(': %a %b %d, %H:%M ' .. separator)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.noempty, mytaglist.buttons)

    -- Create a tasklist widget
--    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(cputextwidget)
--    right_layout:add(cpuwidget)
    right_layout:add(iowidget)
--    right_layout:add(iographwidget)
    right_layout:add(memwidget)
    right_layout:add(cputempwidget)
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mylayoutbox[s])

    local middle_layout = wibox.layout.fixed.horizontal()
    middle_layout:add(weatherwidget)
    middle_layout:add(mytextclock)
    
    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(middle_layout)
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
    --awful.button({ }, 4, awful.tag.viewnext),
    --awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(

    -- Focus 
    awful.key({ modkey,           }, "j",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "k",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "o", function () awful.screen.focus_relative(1) end),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),
    
    awful.key({ modkey,           }, "Right",
        function ()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
    end),
    
    awful.key({ modkey,          }, "Left",
        function ()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
    end),
    
    awful.key({ modkey,          }, "Up",
       function ()
	  awful.client.focus.bydirection("up")
	  if client.focus then client.focus:raise() end
    end),
	
    awful.key({ modkey,          }, "Down",
       function ()
	  awful.client.focus.bydirection("down")
	  if client.focus then client.focus:raise() end
    end),
    
    -- Multiscreen support
    awful.key({ modkey, "Control"   }, "Right",
       function()
	  awful.util.spawn(paths.scripts .. "multiscreen.sh -rc")
	  if beautiful.wallpaper then
	     for s = 1, screen.count() do
		gears.wallpaper.fit(beautiful.wallpaper, s, "#3c352f")
	     end
	  end
    end),

    awful.key({ modkey, "Control"   }, "Left",
       function()
	  awful.util.spawn(paths.scripts .. "multiscreen.sh -lc")
	  if beautiful.wallpaper then
	     for s = 1, screen.count() do
		gears.wallpaper.fit(beautiful.wallpaper, s, "#3c352f")
	     end
	  end
    end),

    awful.key({ modkey, "Control"   }, "Down",
       function()
	  awful.util.spawn(paths.scripts .. "multiscreen.sh -sc")
	  if beautiful.wallpaper then
	     for s = 1, screen.count() do
		gears.wallpaper.fit(beautiful.wallpaper, s, "#3c352f")
	     end
	  end
    end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "j",  function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey,           }, "u",     awful.client.urgent.jumpto),
    awful.key({ modkey, "Shift"   }, "o",     awful.client.movetoscreen ),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "t", function () awful.util.spawn(paths.scripts .. "shutdowndialog.sh") end),

    awful.key({ modkey, "Shift"   }, "e", function () awful.util.spawn(paths.scripts .. "logoffdialog.sh") end),

    awful.key({ modkey, "Shift"   }, "y", function () awful.util.spawn(paths.scripts .. "rebootdialog.sh") end),

    awful.key({ modkey, "Shift"   }, "Right",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey, "Shift"   }, "Left",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "Up", function () awful.client.incwfact(-0.05) end),
    awful.key({ modkey, "Shift"   }, "Down", function () awful.client.incwfact( 0.05) end),
    -- awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    --awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r", function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey },            "d",
              function ()
		 awful.util.spawn("dmenu_run -i -p 'Run command:' -nb '" .. 
				       beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal .. 
				       "' -sb '" .. beautiful.bg_focus .. 
				       "' -sf '" .. beautiful.fg_focus .. "'") 
    end),
    
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),
    --- admin

    awful.key({ modkey, "Shift" }, "l", function ()
        awful.util.spawn(paths.scripts .. "lock.sh")
    end),
    
    
    --- everyday
    
    awful.key({ modkey, "Control" }, "f", function ()
        awful.util.spawn(tools.system.filemanager)
    end),
    
    awful.key({ modkey, "Control" }, "e", function ()
        awful.util.spawn(tools.editor.primary)
    end),
    
    awful.key({ modkey, "Control" }, "w", function ()
        awful.util.spawn(tools.browser.primary)
        --awful.util.spawn('google-chrome-stable')
    end),
    
    awful.key({ modkey, "Control" }, "t", function ()
        awful.util.spawn(tools.terminal)
    end),
    
    awful.key({ modkey, "Control" }, "m", function ()
        awful.util.spawn(tools.email)
    end),
    
    awful.key({ modkey, "Control" }, "s", function ()
        awful.util.spawn("spotify")
    end),
    
    awful.key({ modkey, "Control" }, "c", function ()
          awful.util.spawn("clementine")
    end),
    
    awful.key({ modkey, "Control"}, "p", function ()
        awful.util.spawn("pavucontrol")
    end),
    
    --- the rest
    
    
    awful.key({}, "XF86AudioPrev", function ()
        awful.util.spawn("playerctl previous")
    end),
    
    awful.key({}, "XF86AudioNext", function ()
        awful.util.spawn("playerctl next")
    end),
    
    awful.key({}, "XF86AudioPlay", function ()
        awful.util.spawn("playerctl play-pause")
    end),
    
    awful.key({}, "XF86AudioStop", function ()
        awful.util.spawn("playerctl stop")
    end),
    
    awful.key({ modkey , "Shift"}, "l", function ()
        awful.util.spawn("xscreensaver-command -l")
    end),
    
    awful.key({}, "Print", function ()
        awful.util.spawn("xfce4-screenshooter")
    end),
    
    nil
    
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey, "Shift"   }, "Up",     function (c) awful.client.movetoscreen(c, c.screen+1) end),
    awful.key({ modkey, "Shift"   }, "Down",   function (c) awful.client.movetoscreen(c, c.screen-1) end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    
    { rule = { class = "MPlayer" },
      properties = {
	 floating = true,
	 opacity = 1,
      }
    },
    
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "Gimp" },
      properties = { floating = true } },
    { rule = { class = "Plugin-container" },
        properties = { floating = true } },
    -- Set Firefox to always map on tags number 1 of screen 1.
    { rule_any = { class = { "Firefox", "Chromium" } },
      properties = { tag = tags[1][1] } },

    { rule_any = { class = { "URxvt", "Gnome-terminal", "XTerm" } },
      properties = { tag = tags[1][2] } },

    { rule_any = { class = { "Emacs", "Gvim", "Gedit", "Mousepad", "Eclipse", "Netbeans", "RStudio-bin" } },
      properties = { tag = tags[1][3] } },
    
    { rule_any = { class = { "Files", "Thunar", "Konkeror" } },
      properties = { tag = tags[1][4] } },

    { rule_any = { class = { "TeXstudio" }, instance = { "libreoffice" } },
      properties = { tag = tags[1][5] } },

    { rule_any = { class = { "Thunderbird", "Geary", "Skype", "Pidgin", "Evolution" } },
      properties = { tag = tags[1][6] } },

    { rule_any = { class = { "Spotify", "Banshee", "Rhythmbox", "Clementine", "Audacious", "Vlc", "MPlayer" } },
      properties = { tag = tags[1][7] } },

    { rule_any = { class = { "Gimp" } },
      properties = { tag = tags[1][8] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
--    c:connect_signal("mouse::enter", function(c)
--        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--            and awful.client.focus.filter(c) then
--            client.focus = c
--        end
--    end)
--
    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Autostart programs
-- Here, the programs that must be loaded on login are specified.
-- Use run_once(prg,arg_string,pname,screen) to start a program on login
-- You can also place a .desktop file in .config/autostart/
function run_once(prg,arg_string,pname,screen)
       if not prg then
          do return nil end
       end
       
       if not pname then
          pname = prg
       end
       
       if not arg_string then
          awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
       else
          awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. " ".. arg_string .."' || (" .. prg .. " " .. arg_string .. ")",screen)
       end
end
--run_once("/usr/lib/gnome-settings-daemon/gnome-settings-daemon")
run_once("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
run_once("compton", " -b")
run_once("conky")
run_once("dunst", " -config " .. paths.dunst .."/.dunstrc")
run_once("xfce4-volumed-pulse")
run_once("xscreensaver", " --no-splash")
run_once("xfce4-power-manager")
run_once("blueman-applet")
run_once("nm-applet")
run_once("xscreensaver -no-splash &")
run_once("xautolock -detectsleep -time 35 -locker '".. paths.scripts ..  "lock.sh' -notify 30")

-- }}}
