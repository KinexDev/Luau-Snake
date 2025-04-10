return {
    -- name of the program
    name = "snake",
    -- starting point of the program, the main script.
    main = "src/main.luau",
    -- additional scripts to compile because we are using them via require
    scripts = { 
        "src/game.luau", 
        "src/player.luau", 
        "src/raylib-utils.luau",
        "src/raylib.luau",
        "src/rendering.luau" 
    },
    -- files that are copied over after compilation
    dependencies = {
        "raylib-luau.dll"
    },
    buildWin = true
}