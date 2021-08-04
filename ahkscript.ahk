#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.  ; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

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


AppsKey & w::Send ^+{Left}{Del}
AppsKey & e::Send ^+{Right}{Del}
AppsKey & u::Send +{Home}{Del}

AppsKey & f::BackSpace
AppsKey & d::Del
Capslock & f::BackSpace
Capslock & d::Del


Capslock & Space::Esc


Capslock & -::/
Capslock & #::\

Capslock & w::Send ^{Right}
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
CapsLock & c::^Ins
CapsLock & v::+Ins


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

