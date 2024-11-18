extends Camera3D

@export var camMaxBack: float = 10
@export var camMaxIn: float = 1.5
@export var camMoveStep: float = 0.1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
