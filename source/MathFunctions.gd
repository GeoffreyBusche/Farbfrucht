extends Node


var vec_to_col_matrix = Basis(Vector3(1,0,1),Vector3(-0.5,0.5*(3**0.5),1),Vector3(-0.5,-0.5*(3**0.5),1)).inverse()
	
func vec2_to_color(v):
	var vec3=Vector3(v.x,-v.y,1)
	vec3=2*(vec_to_col_matrix*vec3)
	vec3=vec3.clamp(Vector3(0,0,0),Vector3(1,1,1))
	return Color(vec3.x,vec3.y,vec3.z)

