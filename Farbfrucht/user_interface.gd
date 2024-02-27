extends CanvasLayer


var time:int

# Called when the node enters the scene tree for the first time.
func _ready():
	time=0
	$Time.text=str(time)
	#$UITimer.start()
	
func _on_ui_timer_timeout():
	time+=1
	$Time.text=str(time)


func set_goal(color_vec):
	var color_name
	if color_vec.length_squared()<0.04:
		color_name="nicht grau"
	else:
		var hue=color_vec.angle()
		color_name=hue_to_color_name(hue)
	var color=MathFunctions.vec2_to_color(color_vec)
	$GoalLabel.text="Werde "+color_name+"!"
	$GoalLabel.set("theme_override_colors/font_color",color)



#Takes an angle (float) between -PI and PI representing a color on the color circle
#Outputs a corresponding colorname (string)
func hue_to_color_name(hue):
	var color_angles_list=[-2.5,-1.4,-0.65,-0.15,0.25,1.2,1.7,2.6]
	var color_names_list=["grün","gelb","orange","rot","rosa","violett","blau","türkis"]
	var color_name="türkis"
	for index in range(8):
		if color_angles_list[index]<hue:
			color_name=color_names_list[index]
		else:
			break
	return color_name

func set_score(score):
	$Score.text=str(score)
	
func start_time():
	time=0
	$Time.text=str(time)
	$UITimer.start()




