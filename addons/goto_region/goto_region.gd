@tool
extends EditorPlugin

const GOTO_REGION_DIALOG_SCENE = preload("res://addons/goto_region/ui/goto_region_dialog.tscn")
var GOTO_REGION_SHORTCUT := preload("./resources/goto_region_shortcut.tres")

# Goto Region Dialog Command Name
const COMMAND_PALETTE_GRD_COMMAND_NAME := "Goto Region"
# Goto Region Dialog Key Name
const COMMAND_PALETTE_GRD_KEY_NAME := "goto_region/open_menu"

var goto_region_dialog: ConfirmationDialog


#region Pluin

func _enter_tree() -> void:

	goto_region_dialog = GOTO_REGION_DIALOG_SCENE.instantiate()
	goto_region_dialog.hide()
	EditorInterface.get_script_editor().add_child(goto_region_dialog)

	# Add a command to the command palette
	EditorInterface.get_command_palette().add_command(
		COMMAND_PALETTE_GRD_COMMAND_NAME, COMMAND_PALETTE_GRD_KEY_NAME,
		open_goto_region_dialog, GOTO_REGION_SHORTCUT.get_as_text()
		)


func _exit_tree() -> void:
	# Remove the dialog
	if is_instance_valid(goto_region_dialog):
		goto_region_dialog.queue_free()

	# Remove the command from the command palette
	EditorInterface.get_command_palette().remove_command(COMMAND_PALETTE_GRD_KEY_NAME)

#endregion


func open_goto_region_dialog() -> void:
	var script_editor := EditorInterface.get_script_editor()
	var current := script_editor.get_current_editor()
	if current and is_instance_of(current.get_base_editor(), CodeEdit):
		if current.get_base_editor().has_focus():
			goto_region_dialog.popup_centered(goto_region_dialog.size)


func _shortcut_input(event: InputEvent) -> void:
	if GOTO_REGION_SHORTCUT.matches_event(event):
		open_goto_region_dialog()
		get_viewport().set_input_as_handled()
