> [!IMPORTANT]
> Usable from Godot 4.2 and onward.

# The Plugin
This plugin allows you to quickly browse through the regions in your Godot code, especially helpful for projects with a lot of code. Quickly filter through your regions and (optionally) have a preview your code.
<p align="center">
  <img src="https://github.com/TheLsbt/Goto-Region-Plugin/blob/main/assets/A.png" alt="A" />
  <img src="https://github.com/TheLsbt/Goto-Region-Plugin/blob/main/assets/B.png" alt="B" />
</p>

# Installation
Search for [Goto Region](https://godotengine.org/asset-library/asset/3655) on the Godot Asset Library or get the latest release from this repository.
> [!NOTE]
> To update the plugin, first remove the plugin's root folder ```res://addons/goto_region``` and then follow the [installation steps](https://github.com/TheLsbt/Goto-Region-Plugin#installation).

# Editor Settings
This plugin comes with 2 editor settings.
1. **Show preview**, which can be found at **text_editor/goto_region/show_preview**. *There is also a convienent check button right above the preview in the dialog*.
2. **Preview line count**, which can be found at **text_editor/goto_region/preview_line_count**. This determines the ammount of lines that get shown in the preview.
3. **Open dialog shortcut**, which can be found at **text_editor/goto_region/open_dialog_shortcut**. The default for this shortcut is ```Ctrl+Alt+G```.
<p align="center">
  <img src="https://github.com/TheLsbt/Goto-Region-Plugin/blob/main/assets/D.png" alt="The editor settings" />
</p>

# Command Palette
A command called ```Go To Region``` is added to the [Command Palette](https://docs.godotengine.org/en/stable/classes/class_editorcommandpalette.html#editorcommandpalette). 
<p align="center">
  <img src="https://github.com/TheLsbt/Goto-Region-Plugin/blob/main/assets/C.png" alt="The Command Palette" />
</p>
