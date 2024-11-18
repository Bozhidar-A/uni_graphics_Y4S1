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
	cone.transform.origin = CalculateDffsetFromCylinder(cylinderHeight, cone.height, true)  # Position on top
	spawnHolderNode.add_child(cone)

	# Create the box
	box = CSGBox3D.new()
	box.size = Vector3(1, 0.5, 1)
	box.transform.origin = CalculateDffsetFromCylinder(cylinderHeight, box.size.y, false)  # Position at bottom
	spawnHolderNode.add_child(box)

func CalculateDffsetFromCylinder(cylinderHeight: float, targetHeight: float, isTop: bool) -> Vector3:
	# Calculate offset to position object on top or bottom of the cylinder
	var offsetY = cylinderHeight / 2 + targetHeight / 2
	if not isTop:
		offsetY *= -1
	return Vector3(0, offsetY, 0)

func UpdateCylinderHeight(newH: float):
	# Update the cylinder height
	cylinderHeight = newH
	cylinder.height = cylinderHeight

	# Update cone position
	cone.transform.origin = CalculateDffsetFromCylinder(cylinderHeight, cone.height, true)

	# Update box position
	box.transform.origin = CalculateDffsetFromCylinder(cylinderHeight, box.size.y, false)
