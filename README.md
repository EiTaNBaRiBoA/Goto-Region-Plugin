> [!NOTE]
> To update the plugin, first remove the plugins root folder ```res://addons/goto_region``` and then follow [installation](https://github.com/TheLsbt/Goto-Region-Plugin#installation) steps.

# The Plugin
This plugin allows you to quickly browse through the regions in your Godot code, especially helpful for projects with a lot of code. Quickly filter through your regions and (optionally) have a preview your code.
<p align="center">
  <img src="https://github.com/TheLsbt/Goto-Region-Plugin/blob/main/assets/A.png" alt="A" />
  <img src="https://github.com/TheLsbt/Goto-Region-Plugin/blob/main/assets/B.png" alt="B" />
</p>

# Installation
Search for Goto Region Plugin on the [Godot Asset Library](https://godotengine.org/asset-library/asset/3655) or from this repository.

# Editor Settings
This plugin comes with 2 editor settings.
1. **Show preview**, which can be found at **text_editor/goto_region/show_preview**. *There is also a convienent check button right above the preview in the dialog*.
2. **Preview line count**, which can be found at **text_editor/goto_region/preview_line_count**. This determines the ammount of lines that get shown in the preview.
<p align="center">
  <img src="https://github.com/TheLsbt/Goto-Region-Plugin/blob/main/assets/D.png" alt="The editor settings" />
</p>

# Shortcut & Command Palette
The default shorcut for this plugin ```Ctrl+Alt+G``` however this can be changed using the [Shortcut Resource](https://docs.godotengine.org/en/stable/classes/class_shortcut.html) at **res://addons/goto_region/resources/goto_region_shortcut.tres**.
A command called ```Go To Region``` is added to the [Command Palette](https://docs.godotengine.org/en/stable/classes/class_editorcommandpalette.html#editorcommandpalette). 
<p align="center">
  <img src="https://github.com/TheLsbt/Goto-Region-Plugin/blob/main/assets/C.png" alt="The Command Palette" />
</p>
