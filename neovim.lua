return {
    {
        "bjarneo/aether.nvim",
        name = "aether",
        priority = 1000,
        opts = {
            disable_italics = false,
            colors = {
                -- Monotone shades
                base00 = "#1a1020", -- Dark purple-black background (max contrast)
                base01 = "#2a1e30", -- Statusline bg
                base02 = "#3f3045", -- Selection / bright_black
                base03 = "#8a7a90", -- Comments (clearly muted, still readable)
                base04 = "#c8bcc8", -- Soft foreground (statusline text)
                base05 = "#f5f0f0", -- Default foreground (high contrast off-white)
                base06 = "#ffffff", -- Bright text
                base07 = "#ffffff", -- Pure white

                -- Accent colors (high saturation, max readability)
                base08 = "#ff5252", -- Red (errors, warnings)
                base09 = "#ffb347", -- Orange (variables, warnings)
                base0A = "#ffd54f", -- Yellow (strings)
                base0B = "#69db7c", -- Green (strings, success)
                base0C = "#4dd0e1", -- Cyan (types, special)
                base0D = "#64b5f6", -- Blue (functions, methods)
                base0E = "#ce93d8", -- Magenta (keywords, operators)
                base0F = "#ffab91", -- Tan/peach (deprecated, diff)
            },
        },
        config = function(_, opts)
            require("aether").setup(opts)
            vim.cmd.colorscheme("aether")

            -- Enable hot reload
            require("aether.hotreload").setup()
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "aether",
        },
    },
}