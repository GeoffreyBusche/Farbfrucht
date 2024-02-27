extends ColorRect

signal menu_called

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_menu_button_pressed():
	menu_called.emit()
	hide()
	
func show_manual():
	show()
	$MenuButton.grab_focus()
