extends Node3D

@export var cylinderHeight: float = 1
@export var spawnHolderNode: Node3D

var cylinder: CSGCylinder3D
var cone: CSGCylinder3D

func _ready():
	# init cylendar
	cylinder = CSGCylinder3D.new()
	cylinder.height = cylinderHeight
	cylinder.radius = 0.3
	spawnHolderNode.add_child(cylinder)

	# init cone
	cone = CSGCylinder3D.new()
	cone.cone = true
	cone.height = cylinderHeight/2 #to look good /3?
	cone.radius = 0.5
	var initPos = calculate_cone_offset(cylinderHeight, cylinderHeight/2)
	cone.translate(initPos) # put it ontop (hopefuly)
	spawnHolderNode.add_child(cone) #add to scnene
	
func calculate_cone_offset(cylinder_height: float, cone_height: float) -> Vector3:
	# high reduces equaly from both top and bottom so the top of the cylinder moves by half the change in height
	var offset_y = cylinder_height / 2 + cone_height / 2
	return Vector3(0, offset_y, 0)


func set_cylinder_height(newHeight: float):
	cylinderHeight = newHeight
	
	cylinder.height = cylinderHeight

	var matchedPos = calculate_cone_offset
	cone.translate(matchedPos)
