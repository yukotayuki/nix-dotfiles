# Enter script code
winClass = window.get_active_class()

if "terminal" in winClass or "wezterm" in winClass or "Alacritty" in winClass:
    keyboard.send_keys("<ctrl>+b")
else:
    keyboard.send_keys("<left>")