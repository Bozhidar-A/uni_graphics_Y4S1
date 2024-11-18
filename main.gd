extends Node3D

@export var cylinderHeight: float = 1
@export var spawnHolderNode: Node3D

const coneLookGoodCut = 2  # Adjust cone height for appearance

var cylinder: CSGCylinder3D
var cone: CSGCylinder3D
var box: CSGBox3D

func _ready():
	# Create the cylinder
	cylinder = CSGCylinder3D.new()
	cylinder.height = cylinderHeight
	cylinder.radius = 0.3
	spawnHolderNode.add_child(cylinder)

	# Create the cone
	cone = CSGCylinder3D.new()
	cone.cone = true
	cone.height = cylinderHeight / coneLookGoodCut
	cone.radius = 0.5
	cone.transform.origin = calculate_offset(cylinderHeight, cone.height, true)  # Position on top
	spawnHolderNode.add_child(cone)

	# Create the box
	box = CSGBox3D.new()
	box.size = Vector3(1, 0.5, 1)
	box.transform.origin = calculate_offset(cylinderHeight, box.size.y, false)  # Position at bottom
	spawnHolderNode.add_child(box)

func calculate_offset(cylinder_height: float, target_height: float, is_top: bool) -> Vector3:
	# Calculate offset to position object on top or bottom of the cylinder
	var offset_y = cylinder_height / 2 + target_height / 2
	if not is_top:
		offset_y *= -1
	return Vector3(0, offset_y, 0)

func update_cylinder_height(new_height: float):
	# Update the cylinder height
	cylinderHeight = new_height
	cylinder.height = cylinderHeight

	# Update cone position
	cone.transform.origin = calculate_offset(cylinderHeight, cone.height, true)

	# Update box position
	box.transform.origin = calculate_offset(cylinderHeight, box.size.y, false)
