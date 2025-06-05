# Windows New File Templates - Usage Guide

This document explains how to use the registry files to add custom templates for creating new files from the Windows context menu.

## Table of Contents

- [Overview](#overview)
- [New File Templates](#new-file-templates)
- [Additional Registry Enhancements](#additional-registry-enhancements)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Security Note](#security-note)

## Overview

The registry files in this repository allow you to add custom templates to the Windows "New" context menu. When you right-click in File Explorer and select "New", you'll see options to create files based on your templates.

## New File Templates

### 1. Create Template Files

First, create the template files that will serve as the basis for your new files:

1. Create a directory at `D:\Templates\` if it doesn't already exist
2. Create the following template files:
   - `D:\Templates\default.reg` - Template for new registry files
   - `D:\Templates\default.ps1` - Template for new PowerShell script files

Examples of template content:

#### default.reg

```reg
Windows Registry Editor Version 5.00
```

#### default.ps1

```powershell
# PowerShell Script
# Created on: (Get-Date)
```

### 2. Install Registry Files

1. Double-click on `add_new_reg_template_option.reg` to add the registry entry for .reg file templates
2. Double-click on `add_new_ps1_template_option.reg` to add the registry entry for PowerShell script templates
3. Accept any security prompts that appear

### 3. Using the Templates

1. Open File Explorer and navigate to any folder
2. Right-click in an empty area of the folder
3. From the context menu, select "New"
4. You should now see options for:
   - Registry File
   - PowerShell Script

Clicking on either option will create a new file based on your template.

## Additional Registry Enhancements

### Add to Start Menu

The `add_to_start_menu.reg` file adds a context menu entry that lets you quickly add any file or folder to the Windows Start Menu.

#### Add to Start Menu - Installation

1. Double-click on `add_to_start_menu.reg`
2. Accept any security prompts that appear

#### Add to Start Menu - Usage

1. Right-click on any file or folder
2. Select "Add to Start Menu"
3. A shortcut will be created in your Start Menu's Programs folder
4. A confirmation dialog will appear when the shortcut is created

### Convert Images with ImageMagick

The `convert_to_with_ImageMagick.reg` file adds context menu options to convert image files between different formats.

#### ImageMagick Conversion - Prerequisites

1. Install [ImageMagick](https://imagemagick.org/script/download.php)
2. Ensure `magick.exe` is in your system PATH

#### ImageMagick Conversion - Installation

1. Double-click on `convert_to_with_ImageMagick.reg`
2. Accept any security prompts that appear

#### ImageMagick Conversion - Usage

1. Right-click on any image file
2. Select "Convert to"
3. Choose the desired output format:
   - Convert to JPG
   - Convert to PNG
   - Convert to ICO
   - Convert to SVG
4. The converted file will be created in the same folder with the same base filename but with the new extension

### Default Preview for Registry Files

The `default_preview_reg_files.reg` file changes the default action for .reg files to preview them with PowerToys Registry Preview rather than immediately importing them.

#### Registry Preview - Prerequisites

1. Install [PowerToys](https://github.com/microsoft/PowerToys/releases)
2. Ensure Registry Preview module is enabled in PowerToys

#### Registry Preview - Installation

1. Double-click on `default_preview_reg_files.reg`
2. Accept any security prompts that appear

#### Registry Preview - Usage

1. Double-click on any .reg file to open it in PowerToys Registry Preview
2. Review the changes before applying
3. From the preview, click "Apply" to import the registry file or "Close" to cancel

### Open Physical Folder for Libraries

The `open_physical_folder.reg` file adds a context menu option to open the physical folder location when you're browsing a Windows Library folder.

#### Physical Folder - Installation

1. Double-click on `open_physical_folder.reg`
2. Accept any security prompts that appear

#### Physical Folder - Usage

1. Navigate to any Library folder (like Documents, Pictures, etc.)
2. Right-click in an empty area of the folder
3. Select "Reopen Physical Folder"
4. The actual physical folder location will open in a new Explorer window

## Customization

### Changing Template Locations

If you want to store your templates in a different location:

1. Edit the registry files (e.g., `add_new_reg_template_option.reg`)
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

## Security Note

Registry modifications can affect system behavior. Always back up your registry before making changes.
