# Enter script code
winClass = window.get_active_class()
winTitle = window.get_active_title()

# if winClass == '.autokey-gtk-wrapped..autokey-gtk-wrapped':
if "autokey" in winClass:
    keyboard.send_keys('hoge')
elif "microsoft-edge" in winClass:
    keyboard.send_keys('fuga')
else:
    keyboard.send_keys("class: " + winClass + "\n")
    keyboard.send_keys("title: " + winTitle)