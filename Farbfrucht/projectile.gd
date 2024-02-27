extends Area2D


var damage_amount=Vector2(1,0)
var velocity=Vector2(0,100)



# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.modulate=MathFunctions.vec2_to_color(damage_amount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta


func _on_body_entered(body):
	if body in get_tree().get_nodes_in_group("damageables"):
		body.take_damage(damage_amount)
		$ImpactSound.play()
		$CollisionShape2D.set_deferred("disabled",true)
		$Sprite2D.hide()
		
	elif body in get_tree().get_nodes_in_group("obstacles"):
		$ImpactSound.play()
		$CollisionShape2D.set_deferred("disabled",true)
		$Sprite2D.hide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_impact_sound_finished():
	queue_free()
