extends RigidBody3D

var bodies = Array()
var mouse_movement = Vector2()
const speed_mod = 5000

const speed = 5
var center_of_gravity = Vector3()

func findRigidBodies(node: Node, result: Array) -> void:
	if node.is_class('RigidBody3D') && node.name != name:
		result.push_back(node)
	for child in node.get_children():
		findRigidBodies(child, result)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	findRigidBodies(get_parent(), bodies)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass
	

func _physics_process(delta):
	center_of_gravity = position + center_of_mass
	
	var move_forward = -transform.basis.z * (Input.get_action_strength('ui_up') - Input.get_action_strength('ui_down'))
	var move_right = transform.basis.x * (Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'))
	move_and_collide(speed * (move_forward + move_right) * delta)
	
	for body in bodies:
		move_and_collide(
			speed_mod * center_of_gravity.direction_to(body.position) * (6.674 * pow(10, -11)) * ((mass * body.mass)/(pow(center_of_gravity.distance_to(body.position), 2))) * delta
		)
		# print(speed_mod * center_of_gravity.direction_to(body.position) * (6.674 * pow(10, -11)) * ((mass * body.mass)/(pow(center_of_gravity.distance_to(body.position), 2))) * delta)
	pass
	

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x))
