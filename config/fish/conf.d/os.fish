switch (uname)
    case "Darwin"
        for file in (ls ~/.config/fish/conf.d/macos/)
            source ~/.config/fish/conf.d/macos/"$file"
        end
    case "Linux"
        for file in (ls ~/.config/fish/conf.d/linux/)
            source ~/.config/fish/conf.d/linux/"$file"
        end
end

