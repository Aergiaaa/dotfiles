/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx = 0; /* border pixel of windows */
static const unsigned int snap = 64;    /* snap pixel */
static const int showbar = 1;           /* 0 means no bar */
static const int topbar = 1;            /* 0 means bottom bar */
static const char *fonts[] = {"FiraCode Nerd Font:style=Medium:size=20",
                              "Symbols Nerd Font:style=Regular:size=20",
                              "Noto Sans CJK JP:style=Regular:size=20",
                              "Twitter Color Emoji:size=20"};
static const char dmenufont[] = "FiraCode Nerd Font:style=Medium:size=20";
static const char col_gray1[] = "#222222";
static const char col_gray2[] = "#444444";
static const char col_fonts[] = "#bbbbbb";
static const char col_fonth[] = "#222222";
static const char col_main[] = "#87CEEB";
static const char *colors[][3] = {
    /*               fg         bg         border   */
    [SchemeNorm] = {col_fonts, col_gray1, col_gray2},
    [SchemeSel] = {col_fonth, col_main, col_main},
};

/* tagging */
static const char *tags[] = {"1", "2", "3", "4", "5"};

static const Rule rules[] = {
    /* xprop(1):
     *	WM_CLASS(STRING) = instance, class
     *	WM_NAME(STRING) = title
     */
    /* class      instance    title       tags mask     isfloating   monitor */
    {"qutebrowser", NULL, NULL, 1 << 1, 0, -1},
    {"kitty", NULL, NULL, 1 << 0, 0, -1},
    {"discord", NULL, NULL, 1 << 2, 0, -1},
    {"steam", NULL, NULL, 1 << 3, 0, -1},
    {"zoom", NULL, NULL, 1 << 3, 0, -1},
    {"mpv", NULL, NULL, 1 << 4, 0, -1},
};

/* layout(s) */
static const float mfact = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster = 1;    /* number of clients in master area */
static const int resizehints =
    1; /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen =
    1; /* 1 will force focus on the fullscreen window */
static const int refreshrate =
    120; /* refresh rate (per second) for client move/resize */

static const Layout layouts[] = {
    /* symbol     arrange function */
    {"[]", tile}, /* first entry is default */
    {"><", NULL}, /* no layout function means floating behavior */
    {"[>", monocle},
};

/* key definitions */
#define MODKEY Mod4Mask // Mod4Mask == SUPER
#define TAGKEYS(KEY, TAG)                                                      \
  {MODKEY, KEY, view, {.ui = 1 << TAG}},                                       \
      {MODKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}},               \
      {MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}},                        \
      {MODKEY | ControlMask | ShiftMask, KEY, toggletag, {.ui = 1 << TAG}},

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd)                                                             \
  {                                                                            \
    .v = (const char *[]) { "/usr/local/bin/kitty", "-c", cmd, NULL }          \
  }

/* commands */
static char dmenumon[2] =
    "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = {
    "dmenu_run", "-m",      dmenumon, "-fn",    dmenufont, "-nb",     col_gray1,
    "-nf",       col_fonts, "-sb",    col_main, "-sf",     col_fonth, NULL};

static const char *termcmd[] = {"kitty", "-e", "tmux", "new-session",
                                "-A",    "0",  NULL};
static const char *browserlaunch[] = {"qutebrowser", NULL};

static const char *clip[] = {"/bin/sh", "-c", "~/script/screenshot.sh", NULL};

static const char *volup[] = {"volume.sh", "up", "2", NULL};
static const char *voldown[] = {"volume.sh", "down", "2", NULL};
static const char *volmute[] = {"volume.sh", "mute", NULL};

static const char *brightup[] = {"brightness.sh", "up","5", NULL};
static const char *brightdown[] = {"brightness.sh", "down","5", NULL};

static const char *ctrlpgup[] = {"xdotool", "key", "ctrl+Page_Up", NULL};
static const char *ctrlpgdn[] = {"xdotool", "key", "ctrl+Page_Down", NULL};

static const char *shutdown[] = {"shutdown", "-P", "0", NULL};

static const Key keys[] = {
    /* modifier           key
       function        	argument */

    {MODKEY | ShiftMask, XK_s, spawn, {.v = clip}},
    {0, XF86XK_AudioLowerVolume, spawn, {.v = voldown}},
    {0, XF86XK_AudioRaiseVolume, spawn, {.v = volup}},
    {0, XF86XK_AudioMute, spawn, {.v = volmute}},
    {0, XF86XK_MonBrightnessUp, spawn, {.v = brightup}},
    {0, XF86XK_MonBrightnessDown, spawn, {.v = brightdown}},
    {MODKEY, XF86XK_AudioRaiseVolume, spawn, {.v = brightup}},
    {MODKEY, XF86XK_AudioLowerVolume, spawn, {.v = brightdown}},
    {MODKEY, XK_space, spawn, {.v = dmenucmd}},
    {MODKEY, XK_Return, spawn, {.v = termcmd}},
    {MODKEY, XK_o, spawn, {.v = browserlaunch}},
    {MODKEY, XK_n, spawn, {.v = ctrlpgdn}},
    {MODKEY, XK_m, spawn, {.v = ctrlpgup}},
    {MODKEY, XK_b, togglebar, {0}},
    // { MODKEY,             XK_j,
    // focusstack,     {.i = +1 } }, { MODKEY,             XK_k,
    // focusstack,     {.i = -1 } }, { MODKEY,             XK_i,
    // incnmaster,     {.i = +1 } }, { MODKEY,             XK_d,
    // incnmaster,     {.i = -1 } },
    {MODKEY, XK_Tab, view, {0}},
    {MODKEY, XK_q, killclient, {0}},
    {MODKEY, XK_F1, setlayout, {.v = &layouts[0]}},
    {MODKEY, XK_F2, setlayout, {.v = &layouts[1]}},
    {MODKEY, XK_F3, setlayout, {.v = &layouts[2]}},
    {MODKEY, XK_F4, setlayout, {0}},
    {MODKEY | ShiftMask, XK_F2, togglefloating, {0}},
    {MODKEY, XK_0, view, {.ui = ~0}},
    {MODKEY, XK_Prior, viewneighbor, {.ui = +1}},
    {MODKEY, XK_Next, viewneighbor, {.ui = -1}},
    TAGKEYS(XK_1, 0) TAGKEYS(XK_2, 1) TAGKEYS(XK_3, 2) TAGKEYS(XK_4, 3)
        TAGKEYS(XK_5, 4){MODKEY | ShiftMask, XK_BackSpace, quit, {0}},
    {MODKEY | ShiftMask | ControlMask, XK_Delete, spawn, {.v = shutdown}}};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle,
 * ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
    /* click                event mask      button          function argument */
    {ClkLtSymbol, 0, Button1, setlayout, {0}},
    {ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]}},
    {ClkWinTitle, 0, Button2, zoom, {0}},
    {ClkStatusText, 0, Button2, spawn, {.v = termcmd}},
    {ClkClientWin, MODKEY, Button1, movemouse, {0}},
    {ClkClientWin, MODKEY, Button2, togglefloating, {0}},
    {ClkClientWin, MODKEY, Button3, resizemouse, {0}},
    {ClkTagBar, 0, Button1, view, {0}},
    {ClkTagBar, 0, Button3, toggleview, {0}},
    {ClkTagBar, MODKEY, Button1, tag, {0}},
    {ClkTagBar, MODKEY, Button3, toggletag, {0}},
};
