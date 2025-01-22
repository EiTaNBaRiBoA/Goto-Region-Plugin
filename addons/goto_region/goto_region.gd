@tool
extends EditorPlugin

const GOTO_REGION_DIALOG_SCENE = preload("res://addons/goto_region/ui/goto_region_dialog.tscn")

# Goto Region Dialog Command Name
const COMMAND_PALETTE_GRD_COMMAND_NAME := "Goto Region"
# Goto Region Dialog Key Name
const COMMAND_PALETTE_GRD_KEY_NAME := "goto_region/open_menu"

var goto_region_dialog: ConfirmationDialog
var goto_region_shortcut: Shortcut


#region Pluin init

func _enter_tree() -> void:
	goto_region_shortcut = preload("./resources/goto_region_shortcut.tres")
	goto_region_dialog = GOTO_REGION_DIALOG_SCENE.instantiate()
	goto_region_dialog.hide()
	EditorInterface.get_script_editor().add_child(goto_region_dialog)

	EditorInterface.get_resource_filesystem().filesystem_changed.connect(
		_on_resource_filesystem_changed)

	# Add a command to the command palette
	EditorInterface.get_command_palette().add_command(
		COMMAND_PALETTE_GRD_COMMAND_NAME, COMMAND_PALETTE_GRD_KEY_NAME,
		open_goto_region_dialog, goto_region_shortcut.get_as_text()
		)


func _exit_tree() -> void:
	# Remove the dialog
	if is_instance_valid(goto_region_dialog):
		goto_region_dialog.queue_free()

	# Remove the command from the command palette
	EditorInterface.get_command_palette().remove_command(COMMAND_PALETTE_GRD_KEY_NAME)

	# Disconnect the changed signal from the shortcut
	EditorInterface.get_resource_filesystem().filesystem_changed.disconnect(
		_on_resource_filesystem_changed)


#endregion

func open_goto_region_dialog() -> void:
	var script_editor := EditorInterface.get_script_editor()
	var current := script_editor.get_current_editor()
	if current and is_instance_of(current.get_base_editor(), CodeEdit):
		if current.get_base_editor().has_focus():
			goto_region_dialog.popup_centered(goto_region_dialog.size)


func _shortcut_input(event: InputEvent) -> void:
	if goto_region_shortcut.matches_event(event):
		open_goto_region_dialog()
		get_viewport().set_input_as_handled()


#region Signals

# CODE_SIGNAL
func _on_resource_filesystem_changed() -> void:
	goto_region_shortcut = load("res://addons/goto_region/resources/goto_region_shortcut.tres")
	EditorInterface.get_command_palette().remove_command(COMMAND_PALETTE_GRD_KEY_NAME)
	EditorInterface.get_command_palette().add_command(
		COMMAND_PALETTE_GRD_COMMAND_NAME, COMMAND_PALETTE_GRD_KEY_NAME,
		open_goto_region_dialog, goto_region_shortcut.get_as_text()
		)

#endregion
