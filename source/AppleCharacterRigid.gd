extends RigidBody2D


signal took_damage
signal downed

@export var damage_multiplier=1

const SPEED = 800.0
const JUMP_VELOCITY = -400.0
const COLOR_SPEED = 1

var health = Vector2(1,0)
var health_absolute = 1
var health_minimum = 0.5
var allow_color_steering = true
var screen_size
var reset_state = false
var allow_steering = true
var healable=true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	screen_size = get_viewport_rect().size
	$Sprite2D.modulate=MathFunctions.vec2_to_color(health)
	

	
func _integrate_forces(state):
	if reset_state:
		state.transform = Transform2D(0.0, 0.5*screen_size)
		state.angular_velocity=0
		reset_state = false

func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right","move_up","move_down")
	if direction.length_squared()<0.04:
		direction=Vector2(0,0)
	var target_velocity=SPEED*direction
	var force=target_velocity-linear_velocity
	if allow_steering:
		apply_central_impulse(force)
	

func _process(delta):
	var color_input=Input.get_vector("color_left","color_right","color_up","color_down")
	if allow_color_steering:
		if color_input.length_squared()>0.15:
			var rotation_difference=health.angle_to(color_input)
			rotation_difference=clamp(rotation_difference,-delta*COLOR_SPEED,delta*COLOR_SPEED)
			health=health.rotated(rotation_difference)
			$Sprite2D.modulate=MathFunctions.vec2_to_color(health)
		if Input.is_action_pressed("rotate_color_negative"):
			health=health.rotated(-0.05*delta)
			$Sprite2D.modulate=MathFunctions.vec2_to_color(health)
		if Input.is_action_pressed("rotate_color_positive"):
			health=health.rotated(0.05*delta)
			$Sprite2D.modulate=MathFunctions.vec2_to_color(health)

	
	
func take_damage(amount):
	health+= damage_multiplier*amount
	if healable:
		health_absolute=health.length()
	elif health.length()>health_absolute:
		health=health_absolute*health.normalized()
	else:
		health_absolute=health.length()
	if health_absolute >1:
		health=health.normalized()
		health_absolute=1
	$Sprite2D.modulate=MathFunctions.vec2_to_color(health)
	took_damage.emit()
	if health_absolute<health_minimum and damage_multiplier!=0:
		downed.emit()
		set_process(false)
		allow_steering=false
		damage_multiplier=0

func restart():
	$CollisionShape2D.set("disabled", false)
	set_process(true)
	allow_steering=true
	health=Vector2(1,0)
	health_absolute=1
	$Sprite2D.modulate=MathFunctions.vec2_to_color(Vector2(1,0))

