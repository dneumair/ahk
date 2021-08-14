#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.  ; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.

SetCapsLockState AlwaysOff
caps := false

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

Capslock & w::DeleteWord()
Capslock & b::Send ^{Left}

Capslock & 0::End
Capslock & 7::Home
Capslock & 8::PgDn
Capslock & 9::PgUp

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DeleteWord() {
	if WinActive("ahk_exe alacritty.exe") {
		Send ^w
	} else {
		Send, ^+{left}{delete}
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


GetActiveWindows(){
    DetectHiddenWindows, off
    WinGet, window_list, List
    active_list := []
    Loop %window_list% {
        win_id := window_list%A_Index%
        WinGet, maxi_state, MinMax, ahk_id %win_id%
        WinGetClass, cls, ahk_id %win_id%
        if ( cls == "Shell_TrayWnd" || cls == "Progman" || cls == "WorkerW" || cls == "tooltips_class32" || cls == "SysShadow") {
            continue
        }
        if (maxi_state == -1) {
            continue
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
    active_windows := GetActiveWindows()
    WinGet, current_id,, A
    Sort active_windows, F SortByX
    count := active_windows.Count()
    idx := IndexOf(active_windows, current_id) + offset - 1
    while (Mod(idx, count) < 0) {
        idx := idx + count
    }
    idx := idx + 1
    new_id := active_windows[idx]
    ToolTip %idx% %new_id% %current_id%
    WinActivate ahk_id %new_id%
}


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
            }
            MsgBox %A_Index% a:%a_x% b:%b_x%
        }
        if (!hasChanged) {
            break
        }
    }
    return array
}



printArray() {
    CoordMode, ToolTip, Screen
    active_windows := GetActiveWindows()
    sorted := bubblesort(active_windows)
    for i, w in sorted {
        WinGetPos, x,y, width, height, ahk_id %w%
        WinGetTitle, title, ahk_id %w%
        WinGetClass, class, ahk_id %w%
        ToolTip, %title% `n %class% `n x:%x% y:%y% w:%width% h:%height%, x, y
        sleep 1000
    }
}


isInMonitor(win_id) {
    SysGet, monitor_count, MonitorCount


}

+^F12::Reload
+^F11::printArray()
+^F10::
    SysGet, Mon2, Monitor, 2
    MsgBox, Left: %Mon2Left% -- Top: %Mon2Top% -- Right: %Mon2Right% -- Bottom %Mon2Bottom%.
    return

+#h::Cycle(-1)