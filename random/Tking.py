import tkinter as tk

win = tk.Tk()

win.title("Our First GUI")
# win.resizable(False, False)

coolFrame = tk.Frame(win)
coolFrame.pack()
# tk.[widgetname](root window, properties/configuration)

tk.Label(coolFrame, text="This is our first Label").pack()
tk.Button(coolFrame, text="Hi, im a button.").pack()

label2 = tk.Label(coolFrame, text="Label 2")
label2.pack()

win.mainloop()