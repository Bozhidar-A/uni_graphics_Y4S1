#extends Node3D
#
#func _ready():
	## Create a new Node3D instance
	#var new_node = Node3D.new()
	#
	## Set its position
	#new_node.transform.origin = Vector3(5, 3, -2)  # Replace with your desired coordinates
	#
	## Add it as a child of the current node
	#add_child(new_node)
	#
	## Optional: Add a visual indicator (e.g., MeshInstance3D) for debugging
	#var mesh_instance = MeshInstance3D.new()
	#mesh_instance.mesh = SphereMesh.new()
	#new_node.add_child(mesh_instance)
#
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


extends Node3D

@export var cylinder_height: float = 2.0

#var cylinder: MeshInstance3D
#var cone: MeshInstance3D
var cylinder: CSGCylinder3D
var cone: CSGCylinder3D

#func _ready():
	## Create the cylinder
	#cylinder = MeshInstance3D.new()
	#cylinder.mesh = CylinderMesh.new()
	#(cylinder.mesh as CylinderMesh).height = cylinder_height
	#add_child(cylinder)
#
	## Create the cone
	#cone = MeshInstance3D.new()
	#cone.mesh = ConeMesh.new()
	#cone.translation = Vector3(0, cylinder_height / 2, 0)  # Position it at the top of the cylinder
	#add_child(cone)
#
#func set_cylinder_height(new_height: float):
	#cylinder_height = new_height
	#
	## Update the cylinder height
	#(cylinder.mesh as CylinderMesh).height = cylinder_height
#
	## Update the cone position
	#cone.translation = Vector3(0, cylinder_height / 2, 0)

func _ready():
	# Create the cylinder
	cylinder = CSGCylinder3D.new()
	cylinder.height = cylinder_height
	cylinder.radius = 0.5
	add_child(cylinder)

	# Create the cone
	cone = CSGCylinder3D.new()
	cone.cone = true
	#cone.radius = 1
	var initPos = Vector3(0, cylinder_height, 0)
	cone.translate(initPos) # Position it at the top of the cylinder
	add_child(cone)
