#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.  ; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.

SetCapsLockState AlwaysOff
caps := false

Capslock::return


first_layer := false


LShift & RShift::
    if (caps == true){
        caps := NOT caps
        SetCapsLockState AlwaysOff
    }
    else{
        caps := NOT caps
        SetCapsLockState On
    }
Return


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

CapsLock & u::
    If GetKeyState("LAlt")
        Send {{}
    else	
        Send {(}
Return

CapsLock & i::
    If GetKeyState("LAlt")
        Send {}}
    else	
        Send {)}
Return


CapsLock & o::
    If GetKeyState("LAlt")
        Send {<}
    else	
        Send {[}
Return

CapsLock & p::
    If GetKeyState("LAlt")
        Send {>}
    else	
        Send {]}
Return



CapsLock & -::
    If GetKeyState("LAlt")
        Send {?}
    else	
        Send {/}
Return


CapsLock & h::
    If GetKeyState("LAlt")
        Send ^{Left}
    else	
        Send {Left}
Return


CapsLock & j::
    If GetKeyState("LAlt")
        Send {Down}
    else	
        Send {Down}
Return

CapsLock & k::
    If GetKeyState("LAlt")
        Send {Up}
    else	
        Send {Up}
Return
CapsLock & l::
    If GetKeyState("LAlt")
        Send ^{Right}
    else	
        Send {Right}
Return

CapsLock & f::
    If GetKeyState("LAlt")
        Send {Del}
    else	
        Send {BackSpace}
Return

CapsLock & d::
    If GetKeyState("LAlt")
        Send ^{Del}
    else	
        Send ^{BackSpace}
Return

CapsLock & n::
    If GetKeyState("LAlt")
        Send {Enter}
    else	
        Send {Enter}
Return

CapsLock & m::
    If GetKeyState("LAlt")
        Send {Esc}
    else	
        Send {Esc}
Return

CapsLock & e::
    If GetKeyState("LAlt")
        Send {Home}
    else	
        Send {End}
Return

CapsLock & 2::
    If GetKeyState("LAlt")
        Send {'}
    else	
        Send {"}
Return

CapsLock & ö::
    If GetKeyState("LAlt")
        Send {End}{;}
    else	
        Send {End}
Return

CapsLock & ä::
    If GetKeyState("LAlt")
        Send {=}
    else	
        Send {&}
Return

CapsLock & #::
    If GetKeyState("LAlt")
        Send {\}
    else	
        Send {$}
Return

CapsLock & ,::
    If GetKeyState("LAlt")
        Send {;}
    else	
        Send {;}
Return

CapsLock & .::
    If GetKeyState("LAlt")
        Send {:}
    else	
        Send {:}
Return

CapsLock & r::
    If GetKeyState("LAlt")
        Send +{Tab}
    else	
        Send {Tab}
Return

;;;;; tmux ;;;;
CapsLock & w::Send ^{b}





^#l::Send ^#{Right}
^#h::Send ^#{Left}


;;;;; COPY PASTE ;;;;;
CapsLock & Ins::CopyClipboard()
CapsLock & v::InsertClipboard()


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