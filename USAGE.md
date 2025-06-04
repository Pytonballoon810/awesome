# Windows New File Templates - Usage Guide

This document explains how to use the registry files to add custom templates for creating new files from the Windows context menu.

## Overview

The registry files in this repository allow you to add custom templates to the Windows "New" context menu. When you right-click in File Explorer and select "New", you'll see options to create files based on your templates.

## Setup Instructions

### 1. Create Template Files

First, create the template files that will serve as the basis for your new files:

1. Create a directory at `D:\Templates\` if it doesn't already exist
2. Create the following template files:
   - `D:\Templates\default.reg` - Template for new registry files
   - `D:\Templates\default.ps1` - Template for new PowerShell script files

Examples of template content:

**default.reg**

```reg
Windows Registry Editor Version 5.00
```

**default.ps1**

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

## Security Note

Registry modifications can affect system behavior. Always back up your registry before making changes.
