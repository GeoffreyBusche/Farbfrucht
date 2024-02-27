extends RigidBody2D

signal died

@export var projectile_scene : PackedScene

var target
var health=Vector2(1,0)
var projectile_speed = 500
var acceleration=100


# Called when the node enters the scene tree for the first time.
func _ready():
	$ShotTimer.wait_time=1+randf_range(-0.2,0.2)
	$ShotTimer.start()
	$Sprite2D.modulate=MathFunctions.vec2_to_color(health)



func take_damage(amount):
	health+=amount
	if health.length_squared()>1:
		health=health.normalized()
	$Sprite2D.modulate=MathFunctions.vec2_to_color(health)
	if health.length_squared()<0.5**2:
		died.emit()
		queue_free()

func _physics_process(delta):
	var current_force=acceleration*delta*(target.position-position)
	apply_force(current_force)
	

func shoot():
	var spawn_position=position-Vector2(0,100).rotated(rotation)
	var direction=target.position-spawn_position
	direction=direction.normalized()
	var projectile=projectile_scene.instantiate()
	projectile.velocity=projectile_speed*direction
	projectile.damage_amount=health
	projectile.position=spawn_position
	add_sibling(projectile)
	$ShotSound.play()

func shoot_animated():
	var sprite = $Sprite2D
	var tween = create_tween()
	tween.tween_property(sprite,"scale",Vector2(0.3,0.38),0.3)
	tween.tween_callback(shoot)
	tween.tween_property(sprite,"scale",Vector2(0.3,0.3),0.15)
