# Enter script code
winClass = window.get_active_class()

if "terminal" in winClass:
    keyboard.send_keys("<shift>+<ctrl>+c")
else:
    keyboard.send_keys("<ctrl>+c")