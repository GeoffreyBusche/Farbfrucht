extends Node

@export var projectile_scene: PackedScene
@export var mob_scene: PackedScene
@export var wiper_scene: PackedScene

var screen_size = Vector2(1920,1080)
var player
var ui
var end_screen
var gamemode: int
var goal=Vector2(1,0) #The health vector which the player has to get to
		 #to score a point, in gamemode 1
var score=0
var game_running=false


# Called when the node enters the scene tree for the first time.
func _ready():
	player=$AppleCharacterRigid
	ui=$UserInterface
	end_screen=$EndScreen
	end_screen.hide()
	$Manual.hide()
	ui.hide()
	$Menu.show_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("end_game"):
		end_game(false)



func spawn_projectile(dmg,pos,vel):
	var projectile=projectile_scene.instantiate()
	projectile.position=pos
	projectile.velocity=vel
	projectile.damage_amount=dmg
	
	add_child(projectile)
	move_child(projectile,2)


func _on_projectile_timer_timeout():
	var spawn_location=$SpawnPath/SpawnLocation
	spawn_location.progress_ratio=randf()
	var direction=spawn_location.rotation +PI/2
	direction+=randf_range(-PI/4,PI/4)
	var pos=spawn_location.position
	var vel=600*Vector2(randf_range(0.6,1.3),0).rotated(direction)
	var dmg=Vector2(1,0).rotated(randf_range(-PI,PI))
	
	spawn_projectile(dmg,pos,vel)

func define_color_goal():
	goal=player.health.normalized().rotated(randf_range(1,2*PI-1))
	ui.set_goal(goal)



#Takes gamemode in [0,1,2]
#0: Test 1: erreiche Zielfarbe 2: überlebe
func start_game(gamemode_selection):
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().call_group("projectiles","queue_free")
	get_tree().call_group("mobs","queue_free")
	get_tree().call_group("wipers","queue_free")
	gamemode=gamemode_selection
	ui.set_score(0)
	score=0
	ui.start_time()
	player.reset_state=true
	player.restart()
	$Menu.hide()
	$EndScreen.hide()
	ui.show()
	$Music.play()
	game_running=true
	if gamemode==0:
		player.damage_multiplier=0.2
		player.allow_color_steering=true
		player.healable=true
		player.health_minimum=0.5
		$StaticBody2D.show()
		$StaticBody2D/CollisionShape2D.set_deferred("disabled",false)
		var mob=mob_scene.instantiate()
		mob.acceleration=0
		mob.position=Vector2(1500,800)
		mob.target=player
		mob.health=-player.health
		ui.set_goal(Vector2(0,0))
		add_child(mob)
		move_child(mob,2)
		
	if gamemode==1:
		player.damage_multiplier=1
		$ProjectileTimer.start()
		define_color_goal()
		player.allow_color_steering=false
		player.healable=true
		player.health_minimum=0.5
		$StaticBody2D.hide()
		$StaticBody2D/CollisionShape2D.set_deferred("disabled",true)
		
	if gamemode==2:
		$StaticBody2D.hide()
		$StaticBody2D/CollisionShape2D.set_deferred("disabled",true)
		player.damage_multiplier=0.1
		player.allow_color_steering=true
		player.healable=false
		player.health_minimum=0.25
		ui.set_goal(Vector2(0,0))
		$MobTimer.wait_time=3
		$MobTimer.start()

#Stops the current game and displays ending screen.
#won: bool is true if the game was won, false if lost.
func end_game(won):
	if game_running:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$Music.stop()
		end_screen.show_ending(won,gamemode,score,ui.time)
		$UserInterface/UITimer.stop()
		ui.hide()
		$ProjectileTimer.stop()
		$MobTimer.stop()
		game_running=false
	


func player_take_damage():
	if gamemode==1:
		if abs(player.health.angle_to(goal))<0.5 and player.health_absolute==1:
			score+=1
			ui.set_score(score)
			define_color_goal()
		if score==5:
			end_game(true)


func down_player():
	end_game(false)

func _on_end_screen_game_restarted():
	start_game(gamemode)
	
func go_to_menu():
	$EndScreen.hide()
	$Menu.show_menu()
	get_tree().call_group("projectiles","queue_free")
	get_tree().call_group("mobs","queue_free")
	get_tree().call_group("wipers","queue_free")

func spawn_mob():
	var spawn_position=Vector2(randf_range(150,screen_size.x-150),randf_range(150,screen_size.y-150))
	var mob=mob_scene.instantiate()
	mob.target=player
	mob.position=spawn_position
	mob.health=-player.health.rotated(randf_range(-0.33*PI,0.33*PI))
	add_child(mob)
	move_child(mob,2)
	mob.died.connect(_on_mob_died)
	
	var mobs=get_tree().get_nodes_in_group("mobs")
	if mobs.size()>=5 and randf()>0.33:
		var damage_amount=Vector2.ZERO
		for any_mob in mobs:
			damage_amount+=any_mob.health
		damage_amount=-damage_amount.normalized()
		var spawn_side=["top","bottom","left","right"][randi_range(0,3)]
		spawn_wiper(damage_amount,spawn_side)
		
	
func _on_mob_died():
	score+=1
	ui.set_score(score)
	if $MobTimer.wait_time>=1:
		$MobTimer.wait_time-=0.1
	if score>=50:
		end_game(true)

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
		move_child(wiper,2)


func _on_music_finished():
	$Music.play()

func show_manual():
	$Menu.hide()
	$Manual.show_manual()
