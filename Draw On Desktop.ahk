#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
Menu, Tray, Icon, Screen paint.ico, , 1
Color := "Green.png"
If !FileExist("this_app_ran") {
msgbox, Hello This is the first time this app has run on your pc heres how to use it.`nFor best results draw slowly or you could have a dotted line. . . =)`n`nTo trigger Drawing mode hold (Esc) for one second`nPress (Esc) or (Right click) to Exit Drawing mode`n`n While in Drawing mode Press:`n (R) to use Red.`n (B) to use Blue.`n (G) to use Green.`n`n (Middle wheel) to clear screen.`n`n`nIf you want to here this again go to the tray icon, (also containing options) and select "info".
FileAppend, Nothing to see here just a file that tells this drawing app that its not the first time its been run  =), this_app_ran
}

Gosub, Contextmenu
Begining:

;..............Creat the Draw on Screen tranperent window..................
Gui, +LastFound -Caption -Border +ToolWindow +E0x20
Gui, color, F0F0F0
Gui, Font, s100
SysGet, Monsize, Monitor, 
Gui, Show, x-1920 y1080 h%Monsizebottom% w%Monsizeright%, Draw On Screen
WinSet, TransColor, F0F0F0, Draw On Screen
sleep, 30
Gui, Show, x0 y0
;..........................................................................
Winactivate, Program Manager

;..........Trigger the Draw on screen App..................................
~Esc:: 
Loop, 1 {
sleep, 500
if !GetKeyState("Esc", "P")
break
Gosub, trigger
if !GetKeyState("Esc", "P")
break
}
return


trigger:
if !GetKeyState("Esc", "P") {
Winactivate, Draw On Screen
} Else {
sleep, 30
Gosub, trigger
}
return
;...........................................................................


;...........If Draw on screen is active then activate controls................

#ifwinactive, Draw On Screen
Lbutton::
MouseGetPos, xpos, ypos
Gui, Add, Picture, x%xpos% y%ypos% +BackgroundTrans, %Color%
oldx := xpos, oldy := ypos
while GetKeyState("LButton", "P")
	{
	MouseGetPos, xpos, ypos
	if (xpos != oldx or ypos != oldy) {
		Gui, Add, Picture, x%xpos% y%ypos% +BackgroundTrans, %Color%
		oldx := xpos, oldy := ypos
	}
}
Return


Mbutton::
Gosub, Wipe
Return

;....................Controls...............................................................................
r::gosub, Red
return
g::gosub, Green
return
b::gosub, Blue
return






esc::
	Winactivate, Program Manager
	Return
#ifwinactive
;.............................................................................................................










;.................Tray Option menu..................................................
Contextmenu:
Menu, Tray, NoStandard
Menu, Tray, Add, Info, Info
Menu, Tray, Add
Menu, Tray, Add, Drawing is Always On Top, AOT
Menu, Tray, Add
Menu, Tray, Add, Red pen, Red
Menu, Tray, Add, Blue pen, Blue
Menu, Tray, Add, Green pen, Green
Menu, Tray, Add
Menu, Tray, Add, Clear Screen, wipe
Menu, Tray, Add
Menu, Tray, Add, Exit Draw On Desktop, Exit
Menu, tray, uncheck, Blue pen
Menu, tray, uncheck, Red pen
Menu, tray, check, Green pen
Menu, tray, Uncheck, Drawing is Always On Top
Goto, Begining
return

Info:
msgbox, For best results draw slowly or you could have a dotted line. . . =)`n`nTo trigger Drawing mode hold (Esc) for one second`nPress (Esc) or (Right click) to Exit Drawing mode`n`n While in Drawing mode Press:`n (R) to use Red.`n (B) to use Blue.`n (G) to use Green.`n`n (Middle wheel) to clear screen.
return

AOT:
WinGet, exStyle, ExStyle, Draw On Screen
if (exStyle & 0x8) {
    WinSet, AlwaysOnTop, Off, Draw On Screen
	Menu, tray, Uncheck, Drawing is Always On Top
} else {
    WinSet, AlwaysOnTop, On, Draw On Screen
	Menu, tray, Check, Drawing is Always On Top
}
Return


wipe:
Gui, Destroy
Goto, Begining
return

Red:
Menu, tray, uncheck, Blue pen
Menu, tray, check, Red pen
Menu, tray, uncheck, Green pen

Color := "Red.png"
return

Blue:
Menu, tray, check, Blue pen
Menu, tray, uncheck, Red pen
Menu, tray, uncheck, Green pen

Color := "Blue.png"
return

Green:
Menu, tray, uncheck, Blue pen
Menu, tray, uncheck, Red pen
Menu, tray, check, Green pen

Color := "Green.png"
return
;.......................................................................................
Exit:
ExitApp