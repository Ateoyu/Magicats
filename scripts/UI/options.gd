extends Control

var resolutions = {
	"3840x2160": Vector2i(3840,2160),
	"2560x1440": Vector2i(2560,1440),
	"1920x1080": Vector2i(1920,1080),
	"1366x768": Vector2i(1366,768),
	"1280x720": Vector2i(1280,720),
	"1440x900": Vector2i(1440,900),
	"1600x900": Vector2i(1600,900),
	"1152x648": Vector2i(1152,648),
	"1024x600": Vector2i(1024,600),
	"800x600": Vector2i(800,600)
}

var display_modes = {
	"Windowed": Window.MODE_WINDOWED,
	"Fullscreen": Window.MODE_EXCLUSIVE_FULLSCREEN,
	"Borderless": Window.MODE_FULLSCREEN,
}

@onready var resolutions_option_button: OptionButton = $Panel/HBoxContainer/VBoxContainer/Resolutions
@onready var display_modes_option_button: OptionButton = $Panel/HBoxContainer/VBoxContainer/DisplayModes

func _ready() -> void:
	add_options_to_buttons()
	update_button_values()

func add_options_to_buttons():
	for resolution in resolutions:
		resolutions_option_button.add_item(resolution)
		
	for mode in display_modes:
		display_modes_option_button.add_item(mode)

func update_button_values():
	var current_mode = get_window().mode
	var display_mode_index = display_modes.values().find(current_mode)
	display_modes_option_button.selected = display_mode_index
	
	var window_size_string = str(get_window().size.x, "x", get_window().size.y)
	var resolutions_index = resolutions.keys().find(window_size_string)
	if resolutions_index != -1:
		resolutions_option_button.selected = resolutions_index
	else:
		resolutions_option_button.selected = -1
		resolutions_option_button.text = "Custom: (" + window_size_string + ")"
		

func center_window():
	if get_window().mode == Window.MODE_WINDOWED: # centering doesn't exist in fullscreen modes
		var screen_id = get_window().current_screen
		var screen_rect = DisplayServer.screen_get_usable_rect(screen_id)
		var window_size = get_window().get_size_with_decorations()
		get_window().position = screen_rect.position + (screen_rect.size - window_size) / 2 # shifted up by the size of the window decorations

func _on_option_button_item_selected(index: int) -> void:
	var key = resolutions_option_button.get_item_text(index)
	get_window().size = resolutions[key]
	center_window()

func _on_display_modes_item_selected(index: int) -> void:
	var mode_name = display_modes_option_button.get_item_text(index)
	var target_mode = display_modes[mode_name]
	get_window().mode = target_mode

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/mainMenu.tscn")
