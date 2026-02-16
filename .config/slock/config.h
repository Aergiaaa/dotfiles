/* user and group to drop privileges to */
static const char *user = "aergia";
static const char *group = "aergia";

static const char *colorname[NUMCOLS] = {
    [INIT] = "black",     /* after initialization */
    [INPUT] = "#005577",  /* during input */
    [FAILED] = "#CC3333", /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* Background image path, should be available to the user above */
static const char *background_image =
    "/home/aergia/pict/memship_wp/KOBOSPHERE_Nov_2024.png";

/* default message */
static const char *message = "Suckless: Software that sucks less.";

/* text color */
static const char *text_color = "#000000";

/* text size (must be a valid size) */
static const char *font_name = "JetBrainsMono NFM ExtraBold:size=22";
