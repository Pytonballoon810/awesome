# Windows Productivity Tools - Usage Guide

This document explains how to use the various tools and scripts in this repository for Windows productivity enhancements, automation, and customization.

## Table of Contents

- [Overview](#overview)
- [Windows Registry Enhancements](#windows-registry-enhancements)
  - [New File Templates](#new-file-templates)
  - [Context Menu Additions](#context-menu-additions)
  - [System Behavior Modifications](#system-behavior-modifications)
- [AutoHotkey Scripts](#autohotkey-scripts)
  - [Development and Productivity](#development-and-productivity)
  - [3D Printing Automation](#3d-printing-automation)
  - [System Customization](#system-customization)
- [Browser Extensions](#browser-extensions)
  - [Tampermonkey Userscripts](#tampermonkey-userscripts)
- [Configuration and Templates](#configuration-and-templates)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Security Note](#security-note)

## Overview

This repository contains a collection of Windows productivity tools including:

- **Registry enhancements** for custom file templates and context menu additions
- **AutoHotkey scripts** for automation, productivity, and system customization
- **Browser userscripts** for enhanced web browsing functionality
- **Configuration templates** for quick project setup

All tools are designed to enhance Windows productivity and provide automation for common tasks.

## Windows Registry Enhancements

### New File Templates

The registry files allow you to add custom templates to the Windows "New" context menu.

#### 1. Create Template Files

First, create the template files that will serve as the basis for your new files:

1. Create a directory at `D:\Templates\` if it doesn't already exist
2. Create the following template files:
   - `D:\Templates\default.reg` - Template for new registry files
   - `D:\Templates\default.ps1` - Template for new PowerShell script files

Examples of template content:

##### default.reg

```reg
Windows Registry Editor Version 5.00
```

##### default.ps1

```powershell
# PowerShell Script
# Created on: (Get-Date)
```

#### 2. Install Registry Files

1. Double-click on `registry/add_new_reg_template_option.reg` to add the registry entry for .reg file templates
2. Double-click on `registry/add_new_ps1_template_option.reg` to add the registry entry for PowerShell script templates
3. Accept any security prompts that appear

#### 3. Using the Templates

1. Open File Explorer and navigate to any folder
2. Right-click in an empty area of the folder
3. From the context menu, select "New"
4. You should now see options for:
   - Registry File
   - PowerShell Script

Clicking on either option will create a new file based on your template.

### Context Menu Additions

#### Add to Start Menu

The `registry/add_to_start_menu.reg` file adds a context menu entry that lets you quickly add any file or folder to the Windows Start Menu.

##### Add to Start Menu - Installation

1. Double-click on `registry/add_to_start_menu.reg`
2. Accept any security prompts that appear

##### Add to Start Menu - Usage

1. Right-click on any file or folder
2. Select "Add to Start Menu"
3. A shortcut will be created in your Start Menu's Programs folder
4. A confirmation dialog will appear when the shortcut is created

#### Convert Images with ImageMagick

The `registry/convert_to_with_ImageMagick.reg` file adds context menu options to convert image files between different formats.

##### ImageMagick Conversion - Prerequisites

1. Install [ImageMagick](https://imagemagick.org/script/download.php)
2. Ensure `magick.exe` is in your system PATH

##### ImageMagick Conversion - Installation

1. Double-click on `registry/convert_to_with_ImageMagick.reg`
2. Accept any security prompts that appear

##### ImageMagick Conversion - Usage

1. Right-click on any image file
2. Select "Convert to"
3. Choose the desired output format:
   - Convert to JPG
   - Convert to PNG
   - Convert to ICO
   - Convert to SVG
4. The converted file will be created in the same folder with the same base filename but with the new extension

#### Open Physical Folder for Libraries

The `registry/open_physical_folder.reg` file adds a context menu option to open the physical folder location when you're browsing a Windows Library folder.

##### Physical Folder - Installation

1. Double-click on `registry/open_physical_folder.reg`
2. Accept any security prompts that appear

##### Physical Folder - Usage

1. Navigate to any Library folder (like Documents, Pictures, etc.)
2. Right-click in an empty area of the folder
3. Select "Reopen Physical Folder"
4. The actual physical folder location will open in a new Explorer window

### System Behavior Modifications

#### Default Preview for Registry Files

The `registry/default_preview_reg_files.reg` file changes the default action for .reg files to preview them with PowerToys Registry Preview rather than immediately importing them.

##### Registry Preview - Prerequisites

1. Install [PowerToys](https://github.com/microsoft/PowerToys/releases)
2. Ensure Registry Preview module is enabled in PowerToys

##### Registry Preview - Installation

1. Double-click on `registry/default_preview_reg_files.reg`
2. Accept any security prompts that appear

##### Registry Preview - Usage

1. Double-click on any .reg file to open it in PowerToys Registry Preview
2. Review the changes before applying
3. From the preview, click "Apply" to import the registry file or "Close" to cancel

## AutoHotkey Scripts

These scripts provide productivity enhancements for various tasks. All scripts require [AutoHotkey v2.0](https://www.autohotkey.com/) to be installed.

### Development and Productivity

#### Auto Setup VS Code Workspace

The `AutoHotkey/AutoSetupVSCodeWorkspace.ahk` script automatically copies template files from a designated folder to newly opened VS Code workspaces.

##### Auto Setup VS Code Workspace - Installation

1. Download the `AutoHotkey/AutoSetupVSCodeWorkspace.ahk` script
2. Double-click to run it, or add it to your startup items for persistent use

##### Auto Setup VS Code Workspace - Configuration

1. The script uses `C:\Users\Philipp\Documents\GitHub\awesome\Templates` as the source for template files
2. To change this location, edit the `templateDir` variable in the script

##### Auto Setup VS Code Workspace - Usage

1. The script runs in the background and monitors for new VS Code windows
2. When you open VS Code with a workspace folder, the script:
   - Detects the workspace path from the window title
   - Checks if the workspace directory exists
   - Copies any template files from your template directory to the workspace
   - Shows a notification when files are copied
3. The script creates a log file at `VSCodeSetupLog.txt` for troubleshooting

#### Paste with Escaped Characters

The `AutoHotkey/PasteEscape.ahk` script provides a way to paste clipboard text with special characters automatically escaped, which is useful for programming and scripting tasks.

##### PasteEscape - Installation

1. Download the `AutoHotkey/PasteEscape.ahk` script
2. Double-click to run it, or add it to your startup items for persistent use

##### PasteEscape - Usage

1. Copy text containing special characters (quotes, backslashes, tabs, newlines)
2. Press `Ctrl+Shift+V` to paste the text with special characters properly escaped
3. The script will automatically:
   - Escape backslashes (`\` to `\\`)
   - Escape forward slashes if needed (`/` to `\/`)
   - Escape double quotes (`"` to `\"`)
   - Convert tabs to `\t`
   - Convert newlines to `\n`

#### Generate Documentation with GitHub Copilot

The `AutoHotkey/AutoGenerateDocsUsingCopilotInVSCode.ahk` script automates documentation generation using GitHub Copilot by creating a prompt based on your project files.

##### Copilot Documentation - Prerequisites

- Visual Studio Code with GitHub Copilot Chat extension

##### Copilot Documentation - Installation

1. Download the `AutoHotkey/AutoGenerateDocsUsingCopilotInVSCode.ahk` script
2. Double-click to run it

##### Copilot Documentation - Usage

1. With VS Code open to your project, press `Ctrl+D`
2. The script will:
   - Open Copilot Chat in edit mode
   - Reference your USAGE.md file
   - Generate a prompt asking Copilot to document the features
   - Submit the prompt to Copilot

#### Send Selected Text to GitHub Copilot

The `AutoHotkey/OpenTextInVSCodeCopilot.ahk` script provides quick shortcuts to send selected text from any application directly to GitHub Copilot in VS Code.

##### Copilot Text Selection - Prerequisites

- Visual Studio Code with GitHub Copilot Chat extension

##### Copilot Text Selection - Installation

1. Download the `AutoHotkey/OpenTextInVSCodeCopilot.ahk` script
2. Double-click to run it

##### Copilot Text Selection - Usage

- **Ctrl+G**: Sends selected text to GitHub Copilot Chat in "Ask" mode
  1. Select text in any application
  2. Press `Ctrl+G`
  3. VS Code will activate, open Copilot Chat, and submit your text as a question

- **Ctrl+Shift+G**: Sends selected text to a new GitHub Copilot Chat session
  1. Select text in any application
  2. Press `Ctrl+Shift+G`
  3. VS Code will activate, create a new Copilot Chat, and submit your text

### 3D Printing Automation

#### Auto Turn On 3D Printer Smart Plug

The `AutoHotkey/AutoTurnOn3DPrinterSmartPlug.ahk` script automatically monitors for 3D printing slicer applications and turns on a smart plug connected to your 3D printer when a slicer is opened.

##### 3D Printer Smart Plug - Prerequisites

1. Home Assistant instance running and accessible
2. Smart plug configured in Home Assistant
3. Long-lived access token generated in Home Assistant

##### 3D Printer Smart Plug - Installation

1. Download the `AutoHotkey/AutoTurnOn3DPrinterSmartPlug.ahk` script
2. Create a `.env` file in the same directory as the script with your configuration:

   ```bash
   HomeAssistantURL=http://your-homeassistant-ip:8123
   AuthToken=your_long_lived_access_token_here
   SmartPlugEntityId=switch.3d_printer_plug
   ```

3. Double-click to run the script, or add it to your startup items for persistent use

##### 3D Printer Smart Plug - Configuration

1. The script monitors for these slicer applications by default:
   - Orca Slicer (`orca-slicer.exe`)
   - Bambu Studio (`bambu-studio.exe`)
2. To add more slicer applications, edit the `SlicerProcesses` array in the script
3. Update the `.env` file with your Home Assistant URL, access token, and smart plug entity ID

##### 3D Printer Smart Plug - Usage

1. The script runs in the background and checks for slicer applications every 5 seconds
2. When a monitored slicer application is launched:
   - The script detects the process
   - Sends a command to Home Assistant to turn on the specified smart plug
   - Shows a system notification confirming the action
3. The smart plug remains on until manually turned off through Home Assistant or other automation

### System Customization

#### Disable Start Menu Windows Key

The `AutoHotkey/DisableStartMenuWinKey.ahk` script disables the Windows key from opening the Start Menu while preserving common Windows key combinations.

##### Disable Start Menu Windows Key - Installation

1. Download the `AutoHotkey/DisableStartMenuWinKey.ahk` script
2. Double-click to run it, or add it to your startup items for persistent use

##### Disable Start Menu Windows Key - Usage

1. The script runs in the background and intercepts Windows key presses
2. Pressing the Windows key alone will not open the Start Menu
3. Common key combinations still work:
   - `Win+R`: Opens Run dialog
   - `Win+E`: Opens File Explorer
4. To restore normal Windows key behavior, exit the script or use the registry file alternative

## Browser Extensions

### Tampermonkey Userscripts

These userscripts enhance browser functionality and provide automation for various web services. All scripts require the [Tampermonkey](https://www.tampermonkey.net/) browser extension to be installed.

#### Open Video Services in Edge and Clean Tab

The "Open Video Services in Edge and Clean Tab" userscript automatically redirects video streaming services from Firefox to Microsoft Edge for better DRM support and performance.

##### Video Services Redirect - Prerequisites

1. Install Tampermonkey browser extension in Firefox
2. Microsoft Edge browser installed on the system

##### Video Services Redirect - Installation

1. Open Tampermonkey dashboard in Firefox
2. Click "Create a new script"
3. Copy and paste the contents of `Open Video Services in Edge and Clean Tab.js`
4. Save the script (Ctrl+S)
5. Ensure the script is enabled in Tampermonkey

##### Video Services Redirect - Configuration

The script monitors these video services by default:

- Netflix (`netflix.com`)
- Amazon Prime Video (`primevideo.com`)
- Disney Plus (`disneyplus.com`)
- Hulu (`hulu.com`)
- Amazon Video Germany (`amazon.de/gp/video`)

To add more services, edit the `services` array in the script.

##### Video Services Redirect - Usage

1. The script runs automatically in the background
2. When you navigate to a supported video service:
   - The page is automatically redirected to Microsoft Edge
   - The Firefox tab is cleaned up to show a "Redirected to Edge" message
   - The original URL is preserved in the Edge redirect
3. Links to video services on other websites will also redirect when clicked

## Configuration and Templates

The repository includes template files and configuration examples:

- `AutoHotkey/.env.example` - Environment configuration template for scripts requiring API access
- `Templates/.github/copilot-instructions.md` - GitHub Copilot instruction template for repositories
- Various registry files for system customization

## Customization

### Changing Template Locations

If you want to store your templates in a different location:

1. Edit the registry files (e.g., `registry/add_new_reg_template_option.reg`)
2. Change the path in the `"FileName"` value to your preferred location
3. Re-import the registry file

### Adding More File Types

To add templates for other file types:

1. Create a new registry file following the pattern in the existing files
2. Replace the file extension (e.g., `.ps1` or `.reg`) with your desired extension
3. Set the appropriate `"FileName"` value to point to your template
4. Import the new registry file

## Troubleshooting

- If the template options don't appear in the context menu, try restarting Windows Explorer or your computer
- Ensure the template files exist at the specified paths
- Check that you have proper permissions to modify the registry and access the template files
- Check that any required software dependencies are installed correctly (like PowerToys or ImageMagick)
- For template files, ensure they have appropriate content for their file type
- For the 3D printer smart plug script, ensure Home Assistant is accessible and the access token has the necessary permissions
- For AutoHotkey scripts, ensure AutoHotkey v2.0 is installed and scripts have proper permissions
- For Tampermonkey scripts, verify the extension is enabled and scripts are active in the dashboard

## Security Note

Registry modifications can affect system behavior. Always back up your registry before making changes.
