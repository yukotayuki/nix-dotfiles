# Enter script code
winClass = window.get_active_class()

if "terminal" in winClass:
    keyboard.send_keys("<ctrl>+f")
else:
    keyboard.send_keys("<right>")