# Enter script code
winClass = window.get_active_class()

if "terminal" in winClass or "wezterm" in winClass or "Alacritty" in winClass or "Tilix" in winClass:
    keyboard.send_keys("<ctrl>+f")
else:
    keyboard.send_keys("<right>")
