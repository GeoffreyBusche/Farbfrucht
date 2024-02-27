extends ColorRect

signal game_restarted
signal menu_called

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func show_ending(won,gamemode,score,time):
	if won:
		$GameOverLabel.text="[center][i]Gewonnen![/i][/center]"
		$LossTexture.hide()
		$WinTexture.show()
		$WinSound.play()
	else:
		$GameOverLabel.text="[center][b]Verloren![/b][/center]"
		$LossTexture.show()
		$WinTexture.hide()
		$LossSound.play()
	$ScoreLabel.text="Punktzahl: "+str(score)
	$TimeLabel.text="Zeit: "+str(time)
	var gamemode_list=["Test","Farbjagd","Überleben"]
	$GameModeLabel.text="Spielmodus: "+gamemode_list[gamemode]
	show()
	$AgainButton.grab_focus()



func _on_again_button_pressed():
	hide()
	game_restarted.emit()



func _on_to_menu_button_pressed():
	hide()
	menu_called.emit()

