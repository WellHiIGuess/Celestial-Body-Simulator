extends RigidBody3D


var bodies = Array()
const speed_mod = 5000

func findRigidBodies(node: Node, result: Array) -> void:
	if node.is_class('RigidBody3D') && node.name != name:
		result.push_back(node)
	for child in node.get_children():
		findRigidBodies(child, result)

# Called when the node enters the scene tree for the first time.
func _ready():
	findRigidBodies(get_parent(), bodies)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _physics_process(delta):
	for body in bodies:
		move_and_collide(
			speed_mod * position.direction_to(body.position) * (6.674 * pow(10, -11)) * ((mass * body.mass)/(pow(position.distance_to(body.position), 2))) * delta
		)
	pass
