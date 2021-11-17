#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.  ; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.

SetCapsLockState AlwaysOff
caps := false
global class_ignore_list := []
global class_ignore_file := ".classignore"
importIgnoreList()


Capslock::return

LShift & RShift::
    if (caps == true){
        caps := NOT caps
        SetCapsLockState AlwaysOff
    }
    else{
        caps := NOT caps
        SetCapsLockState On
    }
return

Capslock & f::BackSpace
Capslock & d::Del

Capslock & -::/
Capslock & #::\

CapsLock & ß::?
CapsLock & 0::=

Capslock & w::DeleteWord()
Capslock & b::Send ^{Left}

Capslock & 7::Home
Capslock & 8::End

Capslock & h::
    If GetKeyState("LAlt")
        Send ^{Left}
    else	
        Send {Left}
Return

Capslock & l::
    If GetKeyState("LAlt")
        Send ^{Right}
    else	
        Send {Right}
Return

Capslock & j::
    If GetKeyState("LAlt")
        Send {Down}
    else	
        Send {Down}
Return

Capslock & k::
    If GetKeyState("LAlt")
        Send {Up}
    else	
        Send {Up}
Return


CapsLock & 2::
    SendInput, "
Return

;;;;;;;;;;; emails ;;;;;;;;;;;;;;;;;;;;;
CapsLock & F5::
    if GetKeyState("LAlt")
        Send, david.neumair@outlook.com
Return

CapsLock & F6::
    if GetKeyState("LAlt")
        Send, david.neumair@gmail.com
Return
CapsLock & F7::
    if GetKeyState("LAlt")
        Send, david.neumair@aerq.com
Return

;;;;;;;;;;;; Brackets ;;;;;;;;;;;;;;;;;;;
Capslock & i::
    If GetKeyState("LAlt")
        Send {[}
    else	
        Send {(}
Return

Capslock & o::
    If GetKeyState("LAlt")
        Send {]}
    else	
        Send {)}
Return

Capslock & u::
    If GetKeyState("LAlt")
        Send {<}
    else	
        Send {{}
Return

Capslock & p::
    If GetKeyState("LAlt")
        Send {>}
    else	
    Send {}}
Return

;;;;;;;;; Enter and newline;;;;;;;;;;;;;;;;

Capslock & ö::
    If GetKeyState("LAlt")
    Send {End}+{;} 
        else Send {End}
            Return

Capslock & n::
	If GetKeyState("LAlt")
		Send {Enter} 
	else Send {Enter}
		Return

Capslock & ,::Send {;}

	;;;;; Numpad ;;;
NumpadDot::.
NumpadDel::Send {,}

Capslock & m::Esc

;;;;; COPY PASTE ;;;;;
CapsLock & c::CopyClipboard()
CapsLock & v::InsertClipboard()

Capslock & +::~

;;;; convenientce ;;;;; 
CapsLock & $::$
Capslock & r::Tab
CapsLock & .::Send {:}

;;;; deadkeys ;;;;

Global deadkeys := false

CapsLock & Pause::
	deadkeys := NOT deadkeys
	TrayTip, , deadkeys is %deadkeys%, 2
return

#If NOT deadkeys
	^::Send {ASC 94}
´::Send {U+b4}
+´::Send {U+60}
#If

;;;;; tmux ;;;;
RShift & Capslock::Send ^{b}
LShift & Capslock::Send ^{b}
CapsLock & a::Send ^{b}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DeleteWord() {
	if WinActive("ahk_exe alacritty.exe") {
		Send, ^w
	} else {
		Send, ^{BackSpace}
	}
}

CopyClipboard() {
    if WinActive("ahk_exe alacritty.exe"){
        Send +^c
    } else {
        Send, ^{Ins}
    }
}
InsertClipboard() {
    if WinActive("ahk_exe alacritty.exe"){
        Send +^v
    } else {
        Send, +{Ins}
    }
}

;;;;;;; window switching ;;;;;;;


+#t::WinActivate, ahk_exe alacritty.exe

SortByX(id_a, id_b) {
    WinGetPos, a_x,,, ahk_id %id_a%
    WinGetPos, b_x,,, ahk_id %id_b%
    return a_x < b_x
}

isVisible(win_id) {

}



isIgnored(win_class) {
    global class_ignore_list
    for i, ignored in class_ignore_list {
        if (ignored == win_class) {
            return True
        }
    }
    return False
}

clearIgnored(){
    global class_ignore_list
    class_ignore_list := []
}

addCurrentWinClassToIgnore() {
    global class_ignore_file
    global class_ignore_list
    WinGetClass cls,A
    FileAppend, %cls%`n, %class_ignore_file%
}

importIgnoreList(){
    global class_ignore_file
    global class_ignore_list
    Loop {
        FileReadLine, line, %class_ignore_file%, %A_Index%
        if ErrorLevel
            break
        class_ignore_list.Push(line)
    }
}


GetActiveWindows(){
    DetectHiddenWindows, off
    WinGet, window_list, List
    active_list := []
    Loop %window_list% {
        win_id := window_list%A_Index%
        WinGet, maxi_state, MinMax, ahk_id %win_id%
        WinGetClass, cls, ahk_id %win_id%
        WinGetTitle, title, ahk_id %win_id%
        if (maxi_state == -1) {
            continue
        }
        if (isInMonitor(win_id) == -1) {
            continue
        }
        if (isIgnored(cls)) {
            Continue
        }

        active_list.Push(win_id)
        }
    return active_list
}


IndexOf(array, object) {
    for i, element in array {
        if (element == object) {
            return i
        }
    }
    return -1
}


Cycle(offset) {
    active_windows := bubblesort(GetActiveWindows())
    WinGet, current_id,, A
    
    count := active_windows.Count()
    idx := IndexOf(active_windows, current_id) + offset -1 
    idx := Mod(Idx + count, count) + 1
    new_id := active_windows[idx]
    WinActivate ahk_id %new_id%
    WinGetPos, x,y,w,h, ahk_id %new_id%
    WinGetClass, class, A
    CoordMode, ToolTip, Client 
    ToolTip %idx%: %class%, 0,0
    SetTimer ,RemoveToolTip, 1000
}
RemoveToolTip:
ToolTip
return

bubblesort(array) {
    itemCount := array.Count()
    Loop {
        if (itemCount <= 1) {
            break
        }
        hasChanged := False
        itemCount := itemCount -1
        Loop, %itemCount% {
            a_id := array[A_Index]
            b_id := array[A_Index + 1]
            WinGetPos, a_x,a_y,,,ahk_id %a_id%
            WinGetPos, b_x,b_y,,,ahk_id %b_id%
            if (a_x > b_x) {
                array[A_Index] := b_id
                array[A_Index + 1] := a_id
                hasChanged := True
            } else if ( a_x == b_x ) {
                if (a_id > b_id) {
                    array[A_Index] := b_id
                    array[A_Index + 1] := a_id
                    hasChanged := True
                }
           }
        }
        if (!hasChanged) {
            break
        }
    }
    return array
}



printArray() {
    CoordMode, ToolTip, Client
    active_windows := GetActiveWindows()
    sorted := bubblesort(active_windows)
    for i, w in sorted {
        WinGetPos, x,y, width, height, ahk_id %w%
        WinGetTitle, title, ahk_id %w%
        WinGetClass, class, ahk_id %w%
        WinGet, style, Style, ahk_id %w%
        monitor := isInMonitor(w)
        ToolTip, %title% `n %class% `n x:%x% y:%y% w:%width% h:%height% `n %style% `n monitor:%monitor%, x, y
        sleep 2000
    }
}


isInMonitor(win_id) {
    WinGetPos, x, y, w,h, ahk_id %win_id%
    SysGet, monitor_count, MonitorCount
    Loop, %monitor_count% {
        SysGet area_, Monitor, %A_Index%
        if (x >= area_Left -20 && x <= area_Right + 20 && y >= area_Top -20 && y <= area_Bottom + 20) {
            return A_Index
        } 
    }
    return -1
}

+^F12::Reload
+^F11::printArray()
+^F10::
    sorted := bubblesort(GetActiveWindows())
    isInMonitor(sorted[1])

+#h::Cycle(-1)
+#l::Cycle(1)
+#q::
    addCurrentWinClassToIgnore()
    Reload

+#w::clearIgnored()