extends Node3D

@export var cylinder_height: float = 2.0

#var cylinder: MeshInstance3D
#var cone: MeshInstance3D
var cylinder: CSGCylinder3D
var cone: CSGCylinder3D



func _ready():
	# Create the cylinder
	cylinder = CSGCylinder3D.new()
	cylinder.height = cylinder_height
	cylinder.radius = 0.3
	add_child(cylinder)

	# Create the cone
	cone = CSGCylinder3D.new()
	cone.cone = true
	cone.height = cylinder_height*3 #to look good /3
	cone.radius = 0.5
	#cone.radius = 1
	var initPos = Vector3(0, cylinder_height, 0)
	cone.translate(initPos) # Position it at the top of the cylinder
	add_child(cone)

func set_cylinder_height(new_height: float):
	cylinder_height = new_height
	
	# Update the cylinder height
	cylinder.height = cylinder_height

	# Genearte new pos for cone
	var matchedPos = Vector3(0, cylinder_height, 0)
	cone.translate(matchedPos)
