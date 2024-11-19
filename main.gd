extends Node3D

@export var cylinderHeight: float = 2
@export var spawnHolderNode: Node3D

const coneLookGoodCut = 2  # Adjust cone height for appearance
const colorMAGENTA = Color(0.6,0,0.6)

#objects that make up a pencil
var cylinder: CSGCylinder3D
var cone: CSGCylinder3D
var topBall: CSGSphere3D

func _ready():
	# Create the cylinder
	cylinder = CSGCylinder3D.new()
	cylinder.height = cylinderHeight
	cylinder.radius = 0.5
	ApplyColorToObject(cylinder, Color.GREEN)
	spawnHolderNode.add_child(cylinder)

	# Create the cone
	cone = CSGCylinder3D.new()
	cone.cone = true
	cone.height = cylinderHeight / coneLookGoodCut
	cone.radius = 0.5
	cone.transform.origin = CalculateDffsetFromCylinder(cylinderHeight, cone.height, false, true)  # Position on bottom
	#its at the bottom but still facing up
	#rotate_object_local takes a Vec3 that just says 0/1 what axis to target and radians for sopme reason so just deg to rads and -deg for down
	cone.rotate_object_local(Vector3(1,0,0), deg_to_rad(-180))
	ApplyColorToObject(cone, colorMAGENTA)
	spawnHolderNode.add_child(cone)

	# Create the topBall
	topBall = CSGSphere3D.new()
	topBall.transform.origin = CalculateDffsetFromCylinder(cylinderHeight, topBall.radius, true, false)  # Position at top
	ApplyColorToObject(topBall, Color.RED)
	spawnHolderNode.add_child(topBall)
	
	#add axis
	var axes = AxesVisualizer.new()
	spawnHolderNode.add_child(axes)
	
	#rotate the holder so it looks closer to the example on spawn
	spawnHolderNode.rotate_object_local(Vector3(0,0,1), deg_to_rad(35))

func CalculateDffsetFromCylinder(cylinderHeight: float, targetHeight: float, isTop: bool, includeTargetHeight: bool) -> Vector3:
	# Calculate offset to position object on top or bottom of the cylinder
	var offsetY = 0
	
	#godot uses the center for transform operations
	#to transform an object to the end of another obj add half of the target to the end transform
	#sometimes we dont want to do that
	if includeTargetHeight:
		offsetY = cylinderHeight / 2 + targetHeight / 2
	else:
		offsetY = cylinderHeight / 2
	 
	if not isTop:
		offsetY *= -1 #they all spawn at 0,0,0 so just 
	return Vector3(0, offsetY, 0)
	
func ApplyColorToObject(object: Node3D, color: Color):
	var material = StandardMaterial3D.new()
	material.albedo_color = color  # Set the albedo (base) color
	
	# Apply the material to the object
	if object is CSGShape3D:
		object.material = material
	else:
		print("Cannot apply material: Object is not a CSGShape3D")
	

func UpdateCylinderHeight(newH: float):
	# Update the cylinder height
	cylinderHeight = newH
	cylinder.height = cylinderHeight

	# Update cone position
	cone.transform.origin = CalculateDffsetFromCylinder(cylinderHeight, cone.height, false, true)

	# Update topBall position
	topBall.transform.origin = CalculateDffsetFromCylinder(cylinderHeight, topBall.radius, true, false)
	
