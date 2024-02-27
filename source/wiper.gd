extends Area2D

#A type of "projectile" of rectangular shape which damages mobs and player on contact.
#Does not disappear on collision.

var damage_amount=Vector2(1,0)
var velocity=Vector2(0,200)


# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.color=MathFunctions.vec2_to_color(damage_amount)
	$HumSound.play()

func set_damage(amount):
	damage_amount=amount
	$ColorRect.color=MathFunctions.vec2_to_color(damage_amount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += delta*velocity
	var random_number=randf_range(-0.1,0.1)
	$ColorRect.scale.y=1+random_number
	$ColorRect.position.y=-40-20*random_number

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body in get_tree().get_nodes_in_group("damageables"):
		if body in get_tree().get_nodes_in_group("mobs"):
			body.take_damage(damage_amount)
		else:
			body.take_damage(5*damage_amount)




func _on_area_entered(area):
	if area in get_tree().get_nodes_in_group("projectiles"):
		area.queue_free()
