extends ColorRect

signal start_button_pressed(gamemode)
signal manual_button_pressed



# Called when the node enters the scene tree for the first time.
func _ready():
	pass




func _on_end_button_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit(0)



func _on_mode_0_button_pressed():
	start_button_pressed.emit(0)
	

func _on_mode_1_button_pressed():
	start_button_pressed.emit(1)


func _on_mode_2_button_pressed():
	start_button_pressed.emit(2)
	

func show_menu():
	show()
	$Mode0Button.grab_focus()


func _on_manual_button_pressed():
	manual_button_pressed.emit()
