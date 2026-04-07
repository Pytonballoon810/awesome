#Requires AutoHotkey v2.0

; Disable Windows key alone
LWin::{
    Return
}
RWin::{
    Return
}

; Allow combos like Win+R, Win+E, etc.
#r::{
    Run("explorer shell:::{2559a1f3-21d7-11d4-bdaf-00c04f60b9f0}") ; Run dialog
}
#e::{
    Run("explorer.exe") ; File Explorer
}
