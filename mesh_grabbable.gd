extends RigidBody3D

@export var rotationSpeed: float = 0.5

var rotating = false

var prevMousePos
var currMousePos

func _process(delta):
	if Input.is_action_just_pressed("Rotate"):
		rotating = true
		prevMousePos = get_viewport().get_mouse_position()
	if Input.is_action_just_released("Rotate"):
		rotating = false
		
	if rotating:
		currMousePos = get_viewport().get_mouse_position()
		var mouseDelta = currMousePos - prevMousePos

		rotate_y(mouseDelta.x * rotationSpeed * delta)  # Horizontal (yaw) inverted
		rotate_x(mouseDelta.y * rotationSpeed * delta)  # Vertical (pitch) inverted
		#inverting feels better

		prevMousePos = currMousePos
