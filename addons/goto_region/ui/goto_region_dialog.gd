@tool
extends ConfirmationDialog


const ES_SHOW_PREVIEW := "text_editor/goto_region/show_preview"
const ES_PREVIEW_LINE_COUNT := "text_editor/goto_region/preview_line_count"

@onready var search_edit: LineEdit = $Container/Content/SearchEdit
@onready var show_preview_check: CheckButton = $Container/Content/HBoxContainer/ShowPreviewCheck
@onready var item_list: ItemList = $Container/Content/ItemListPreviewSplit/ItemList
@onready var preview: CodeEdit = $Container/Content/ItemListPreviewSplit/Preview

## The regions of the current script editor
var cached_regions: Array[Dictionary] = []
## The current script editor.
var cached_editor: CodeEdit
## Should draw preview.
var should_show_preview: bool:
	set(value):
		should_show_preview = value
		EditorInterface.get_editor_settings().set(ES_SHOW_PREVIEW, value)
	get:
		return EditorInterface.get_editor_settings().get(ES_SHOW_PREVIEW)
## Affects EditorSettings:text_editor/goto_regions/preview_line_count.
## Determines the amount of lines to preview.
var preview_line_count: int:
	get:
		return EditorInterface.get_editor_settings().get(ES_PREVIEW_LINE_COUNT)


## Prepares this window by gathering the current script editor's regions and updating the list
# CODE_SIGNAL
func prepare() -> void:
	cached_editor = null

	var script_editor := EditorInterface.get_script_editor()
	var current := script_editor.get_current_editor()

	if is_instance_valid(current) and is_instance_of(current.get_base_editor(), CodeEdit):
		cached_editor = current.get_base_editor()
		cache_code_regions()
		preview.syntax_highlighter = cached_editor.syntax_highlighter

	preview.clear()
	search_edit.clear()
	update_list()

	await get_tree().process_frame
	await get_tree().process_frame
	search_edit.grab_focus()


func confirm_region() -> void:
	var selected := item_list.get_selected_items()
	if selected.size() == 0:
		return
	var line: int = item_list.get_item_metadata(selected[0])

	cached_editor.grab_focus()
	EditorInterface.get_script_editor().goto_line(line)

	await get_tree().process_frame
	await get_tree().process_frame

	hide()


## There is no Godot way to get regions so this function fins them using the default syntax.
func cache_code_regions() -> void:
	if not is_instance_valid(cached_editor):
		return

	cached_regions.clear()
	var code_region_start_tag := "#%s " %cached_editor.get_code_region_start_tag()
	var current_region := {}
	var is_region_open := false
	for line in range(cached_editor.get_line_count()):
		if cached_editor.is_line_code_region_start(line):
			if is_region_open:
				current_region["region_end"] = -1
				cached_regions.append(current_region)
				is_region_open = false

			current_region = {}
			current_region["region_start"] = line
			var identifier := cached_editor.get_line(line).lstrip(code_region_start_tag)
			current_region["identifier"] = identifier
			is_region_open = true

		elif cached_editor.is_line_code_region_end(line) and is_region_open:
			current_region["region_end"] = line
			cached_regions.append(current_region)
			is_region_open = false


func update_list() -> void:
	item_list.clear()
	for region in cached_regions:
		var region_start: int = region["region_start"]
		var region_end: int = region["region_end"]
		var identifier: String = region["identifier"]

		var full_identifier := ""
		# This means that the region doesnt have a close tag
		if region_end < 0:
			full_identifier = "%s : %d → ?" %[identifier, region_start + 1]
		else:
			full_identifier = "%s : %d → %d" %[identifier, region_start + 1, region_end + 1]
		var lowered_full_identifier := full_identifier.to_lower()

		var search_text := search_edit.text.to_lower()
		if lowered_full_identifier.contains(search_text) or search_text.length() == 0:
			item_list.add_item(full_identifier)
			item_list.set_item_metadata(item_list.item_count - 1, region_start)

	if item_list.item_count > 0:
		item_list.select(0)
		update_preview()


func update_preview() -> void:
	if not should_show_preview:
		return
	var selected := item_list.get_selected_items()
	if selected.size() > 0:
		var line: int = item_list.get_item_metadata(selected[0])
		preview.text = ""
		for i in range(line, clamp(line + preview_line_count, 0, cached_editor.get_line_count())):
			preview.text += "%s\n" % cached_editor.get_line(i)
	else:
		preview.clear()


func _init() -> void:
	about_to_popup.connect(prepare)
	confirmed.connect(_on_confirmed)

	var settings := EditorInterface.get_editor_settings()
	settings.settings_changed.connect(_on_editor_settings_changed)

	settings.add_property_info({
		"name": ES_SHOW_PREVIEW,
		"type": TYPE_BOOL,
	})

	settings.add_property_info({
		"name": ES_PREVIEW_LINE_COUNT,
		"type": TYPE_INT,
	})

	if not settings.has_setting(ES_SHOW_PREVIEW):
		settings.set(ES_SHOW_PREVIEW, false)
		settings.set_initial_value(ES_SHOW_PREVIEW, true, true)

	if not settings.has_setting(ES_PREVIEW_LINE_COUNT):
		settings.set(ES_PREVIEW_LINE_COUNT, 8)
		settings.set_initial_value(ES_PREVIEW_LINE_COUNT, 8, true)


#region Signals

# CODE_SIGNAL
func _on_editor_settings_changed() -> void:
	var settings := EditorInterface.get_editor_settings()
	var changed := settings.get_changed_settings()

	if changed.has(ES_SHOW_PREVIEW):
		should_show_preview = settings.get(ES_SHOW_PREVIEW)
		show_preview_check.set_pressed_no_signal(should_show_preview)
		preview.visible = should_show_preview
		update_preview()
	elif changed.has(ES_PREVIEW_LINE_COUNT):
		should_show_preview = settings.get(ES_PREVIEW_LINE_COUNT)
		update_preview()


# CODE_SIGNAL
func _on_confirmed() -> void:
	confirm_region()


# CODE_SIGNAL
func _on_close_requested() -> void:
	hide()


# CODE_SIGNAL
func _on_search_edit_text_changed(_new_text: String) -> void:
	update_list()


# CODE_SIGNAL
func _on_search_edit_gui_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var selected := item_list.get_selected_items()
		if event.is_pressed() and selected.size() > 0:
			if event.keycode == KEY_UP:
				item_list.select(wrap(selected[0] - 1, 0, item_list.item_count))
				update_preview()
			elif event.keycode == KEY_DOWN:
				item_list.select(wrap(selected[0] + 1, 0, item_list.item_count))
				update_preview()


func _on_item_list_item_activated(_index: int) -> void:
	confirm_region()


func _on_search_edit_text_submitted(_new_text: String) -> void:
	confirm_region()


func _on_item_list_item_selected(_index: int) -> void:
	update_preview()


func _on_show_preview_check_toggled(toggled: bool) -> void:
	should_show_preview = toggled

#endregion
