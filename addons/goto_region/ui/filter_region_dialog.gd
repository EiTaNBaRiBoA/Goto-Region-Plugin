@tool
extends Window

#region This is my first region
#endregion
#region This is my second region
#endregion
#region Start of region 3
#endregion
#region Start of region 4
#endregion
#region Start of region 5
#endregion
#region Start of region 6
#endregion
#region Start of region 7
# This is awesome
# this is inside a region
#endregion

const PREVIEW_STEPS = 8

@onready var item_list: ItemList = $Container/Content/HBoxContainer/ItemList
@onready var search_edit: LineEdit = $Container/Content/SearchEdit
@onready var preview: CodeEdit = $Container/Content/HBoxContainer/Preview

var cached_regions: Dictionary = {}
var cached_editor: CodeEdit

func update_cache(editor: CodeEdit) -> void:
	cached_editor = editor

	preview.syntax_highlighter = editor.syntax_highlighter

	search_edit.clear()
	cached_regions = gather_code_regions(editor)
	search_edit.grab_focus()
	update_list()
	update_preview()


func gather_code_regions(editor: CodeEdit) -> Dictionary:
	var regions := {}
	for line in range(editor.get_line_count()):
		if editor.is_line_code_region_start(line):
			var identifier := editor.get_line(line).lstrip("#region ")
			regions[line] = identifier
	return regions

func _on_close_requested() -> void:
	close()

func _on_search_edit_text_changed(_new_text: String) -> void:
	update_list()

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

func _on_item_list_item_activated(index: int) -> void:
	_index_activated(index)


func _index_activated(index: int) -> void:
	cached_editor.grab_focus()
	var line: int = item_list.get_item_metadata(index)
	cached_editor.remove_secondary_carets()
	cached_editor.set_caret_column(0, true, 0)
	cached_editor.set_caret_line(line, true, true, 0, 0)
	cached_editor.merge_overlapping_carets()
	close()


func update_list() -> void:
	item_list.clear()
	for line in cached_regions.keys():
		var identifier: String = cached_regions[line]
		var full_identifier := ("%s:%d" % [identifier, line + 1])
		if full_identifier.containsn(search_edit.text) or search_edit.text.length() == 0:
			item_list.add_item(full_identifier)
			item_list.set_item_metadata(item_list.item_count - 1, line)

	if item_list.item_count > 0:
		item_list.select(0)
		update_preview()


func close() -> void:
	get_parent().remove_child(self)


func get_lines_under(line: int, high: int) -> String:
	var lines := ""
	for i in range(line, clamp(line + high, 0, cached_editor.get_line_count())):
		lines += "%s\n" % cached_editor.get_line(i)
	return lines


func _on_search_edit_text_submitted(_new_text: String) -> void:
	var selected := item_list.get_selected_items()
	if selected.size() > 0:
		_index_activated(selected[0])


func update_preview() -> void:
	var selected := item_list.get_selected_items()
	if selected.size() > 0:
		var line: int = item_list.get_item_metadata(selected[0])
		preview.text = get_lines_under(line, PREVIEW_STEPS)


func _on_item_list_item_selected(_index: int) -> void:
	update_preview()
