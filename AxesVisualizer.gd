extends Node3D
class_name AxesVisualizer

# Parameters for the axes
@export var length: float = 2.0
@export var thickness: float = 0.01

func _ready():
	CreateAxis()

func CreateAxis():
	# X Axis (Red)
	var x_axis = CreateCylinder(length, thickness, Color.RED)
	x_axis.rotation_degrees.z = 90
	x_axis.transform.origin = Vector3(length / 2, 0, 0)
	add_child(x_axis)

	# Y Axis (Green)
	var y_axis = CreateCylinder(length, thickness, Color.GREEN)
	y_axis.transform.origin = Vector3(0, length / 2, 0)
	add_child(y_axis)

	# Z Axis (Blue)
	var z_axis = CreateCylinder(length, thickness, Color.BLUE)
	z_axis.rotation_degrees.x = 90
	z_axis.transform.origin = Vector3(0, 0, length / 2)
	add_child(z_axis)

func CreateCylinder(length: float, thickness: float, color: Color) -> CSGCylinder3D:
	var mesh = CSGCylinder3D.new()
	mesh.height = length
	mesh.radius = thickness
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	mesh.material = material
	return mesh
