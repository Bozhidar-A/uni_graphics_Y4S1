extends Node3D

func _ready():
	# Create a new Node3D instance
	var new_node = Node3D.new()
	
	# Set its position
	new_node.transform.origin = Vector3(5, 3, -2)  # Replace with your desired coordinates
	
	# Add it as a child of the current node
	add_child(new_node)
	
	# Optional: Add a visual indicator (e.g., MeshInstance3D) for debugging
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = SphereMesh.new()
	new_node.add_child(mesh_instance)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
