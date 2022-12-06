extends Control

#
# Buttons
#
onready var start_button := $VBoxContainer/Buttons/Start
onready var settings_button := $VBoxContainer/Buttons/Settings
onready var exit_button := $VBoxContainer/Buttons/Exit

func _on_Start_pressed():
	pass


func _on_Settings_pressed():
	pass


func _on_Exit_pressed():
	get_tree().quit()

# Prevent the player from clicking too many things and fucking everything up
func _disable_Buttons():
	start_button.mouse_filter = MOUSE_FILTER_IGNORE
	settings_button.mouse_filter = MOUSE_FILTER_IGNORE
