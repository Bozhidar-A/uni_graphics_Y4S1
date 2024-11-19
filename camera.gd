extends Camera3D

@export var camMaxBack: float = 10
@export var camMaxIn: float = 1.5
@export var camMoveStep: float = 0.1
var disabledControls = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for input:SpinBox in get_tree().get_nodes_in_group("VarSpinBoxUIGroup"):
		#https://github.com/godotengine/godot/issues/43338#issuecomment-723680957
		#this is beyond stupid
		input.get_line_edit().focus_entered.connect(OnInputFocus.bind(input))
		input.get_line_edit().focus_exited.connect(OnInputStopFocus.bind(input))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if disabledControls:
		return
	
	if Input.is_action_just_pressed("CamIn"):
		if self.global_transform.origin.z <= camMaxIn:
			self.global_transform.origin.z = camMaxIn
			return
		
		self.global_transform.origin.z -= camMoveStep
		
	if Input.is_action_just_pressed("CamBack"):
		if self.global_transform.origin.z >= camMaxBack:
			self.global_transform.origin.z = camMaxBack
			return
		
		self.global_transform.origin.z += camMoveStep

func OnInputFocus(input:SpinBox) -> void:
	print(input.name)
	disabledControls = true

func OnInputStopFocus(input:SpinBox) -> void:
	disabledControls = false
