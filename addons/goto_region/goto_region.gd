@tool
extends EditorPlugin

const FILTER_REGION_DIALOG_SCENE = preload("res://addons/goto_region/ui/filter_region_dialog.tscn")

var button := Button.new()
var filter_region_dialog: Window


func _enter_tree() -> void:
	filter_region_dialog = FILTER_REGION_DIALOG_SCENE.instantiate()

	var script_editor := EditorInterface.get_script_editor()

	var menu_hbox := script_editor.get_child(0).get_child(0)
	menu_hbox.add_child(button)

	button.text = "Regions"

	button.pressed.connect(_on_region_button_pressed)



func _exit_tree() -> void:
	if button:
		button.queue_free()

	if filter_region_dialog.is_inside_tree():
		filter_region_dialog.queue_free()


func _on_region_button_pressed() -> void:
	EditorInterface.popup_dialog(filter_region_dialog)

	var script_editor := EditorInterface.get_script_editor()
	var current: ScriptEditorBase = script_editor.get_current_editor()

	if current and is_instance_of(current.get_base_editor(), CodeEdit):
		filter_region_dialog.update_cache(current.get_base_editor())
