extends Control


var Player
# Called when the node enters the scene tree for the first time.
func _ready():
	Player=get_node("/root/Main/AppleCharacterRigid")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Player:
		$HealthPointer.scale.x=Player.health_absolute
		$HealthPointer.rotation=Player.health.angle()
	
