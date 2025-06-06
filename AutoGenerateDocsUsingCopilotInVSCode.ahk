#Requires AutoHotkey v2.0

^d::
{
    ; Open Command Palette
    Send("^+p")
    Sleep 300

    ; Run 'Chat: New Chat'
    Send("Chat: New Chat")
    Sleep 300
    Send("{Enter}")
    Sleep 500

    ; Open Command Palette
    Send("^+p")
    Sleep 300

    ; Change chat mode to 'Edit'
    Send("Chat: Open Chat (Edit)")
    Sleep 300
    Send("{Enter}")
    Sleep 500

    ; Type final prompt and press Enter
    Send("Respecting the formatting of the ")
    Sleep 300

    ; Type #USAGE.md and press Enter
    SendText("#USAGE.m")
    Sleep 200
    Send("d") ; send filename in 2 parts to make sure copilot suggests the correct file
    Sleep 300
    Send("{Enter}")
    Sleep 500

    SendText(
        "file, generate documentation for the added features. Disregard any #changes only made for formatting purposes. Also make sure to respect best practices for md files and documentation in general. If necessary, also correct any spelling or grammar mistakes."
    )

    Send("{Enter}")
}
return