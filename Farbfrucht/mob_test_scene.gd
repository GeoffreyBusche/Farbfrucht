extends Node2D

@export var wiper_scene: PackedScene


var screen_size = Vector2(1920,1080)
# Called when the node enters the scene tree for the first time.
func _ready():
	$Mob.target=$AppleCharacterRigid
	$Mob1.target=$AppleCharacterRigid
	$Mob2.target=$AppleCharacterRigid
	spawn_wiper(Vector2(-1,0),"left")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_wiper(damage_amount,side_name):
	var wiper=wiper_scene.instantiate()
	wiper.set_damage(damage_amount)
	if side_name=="top":
		wiper.rotation=0
		wiper.position=Vector2(0,0)
		wiper.velocity=Vector2(0,200)
	if side_name=="left":
		wiper.rotation=-PI/2
		wiper.position=Vector2(0,screen_size.y)
		wiper.velocity=Vector2(0,200).rotated(-PI/2)
	if side_name=="right":
		wiper.rotation=PI/2
		wiper.position=Vector2(screen_size.x,0)
		wiper.velocity=Vector2(0,200).rotated(PI/2)
	if side_name=="bottom":
		wiper.rotation=PI
		wiper.position=screen_size
		wiper.velocity=Vector2(0,200).rotated(PI)
	if side_name in ["top","left","right","bottom"]:
		add_child(wiper)
