extends Node3D

@export var cylinderHeight: float = 2
@export var cylinderWidth: float = 0.5
@export var coneHeight: float = 1

@onready var spawnHolderNode: RigidBody3D = $MeshGrabbable
@onready var light1: SpotLight3D = $LightSpot1
@onready var light2: SpotLight3D = $LightSpot2
@onready var loadNew: Button = $Camera3D/CanvasLayer/PanelContainer/VarUI/LoadNew
@onready var nativeDialog: NativeFileDialog = NativeFileDialog.new()

@onready var penLen: SpinBox = $Camera3D/CanvasLayer/PanelContainer/VarUI/PenLenContainer/PenLen
@onready var penWidth: SpinBox = $Camera3D/CanvasLayer/PanelContainer/VarUI/PenWidthContainer/PenWidth
@onready var penConeLen: SpinBox = $Camera3D/CanvasLayer/PanelContainer/VarUI/PenConeLenContainer/PenConeLen
@onready var light1X: SpinBox = $Camera3D/CanvasLayer/PanelContainer/VarUI/Light1XContainer/Light1X
@onready var light1Y: SpinBox = $Camera3D/CanvasLayer/PanelContainer/VarUI/Light1YContainer/Light1Y
@onready var light1Z: SpinBox = $Camera3D/CanvasLayer/PanelContainer/VarUI/Light1ZContainer/Light1Z
@onready var light2Point: SpinBox = $Camera3D/CanvasLayer/PanelContainer/VarUI/Light2PointDirContainer/Light2Point

const colorMAGENTA = Color(0.6,0,0.6)

#objects that make up a pencil
var cylinder: CSGCylinder3D
var cone: CSGCylinder3D
var topBall: CSGSphere3D

#holder vars
var light1XVal: float
var light1YVal: float
var light1ZVal: float
var light2PointVal: float

#debug lables
@onready var penLenDebug: Label = $Camera3D/CanvasLayer/PanelContainer2/VarUIHardRead/PenLenContainer/PenLenValD
@onready var penWidthDebug: Label = $Camera3D/CanvasLayer/PanelContainer2/VarUIHardRead/PenWidthContainer/PenWidthValD
@onready var penConeLenDebug: Label = $Camera3D/CanvasLayer/PanelContainer2/VarUIHardRead/PenConeLenContainer/PenConeLenValD
@onready var light1XDebug: Label = $Camera3D/CanvasLayer/PanelContainer2/VarUIHardRead/Light1XContainer/Light1XValD
@onready var light1YDebug: Label = $Camera3D/CanvasLayer/PanelContainer2/VarUIHardRead/Light1YContainer/Light1YValD
@onready var light1ZDebug: Label = $Camera3D/CanvasLayer/PanelContainer2/VarUIHardRead/Light1ZContainer/Light1ZValD
@onready var light2PointDebug: Label = $Camera3D/CanvasLayer/PanelContainer2/VarUIHardRead/Light2PointDirContainer/Light2PointValD


func _ready():
	# Create the cylinder
	cylinder = CSGCylinder3D.new()
	cylinder.height = cylinderHeight
	cylinder.radius = cylinderWidth
	#ApplyColorToObject(cylinder, Color.GREEN)
	spawnHolderNode.add_child(cylinder)

	# Create the cone
	cone = CSGCylinder3D.new()
	cone.cone = true
	cone.height = coneHeight
	cone.radius = cylinderWidth
	cone.transform.origin = CalculateDffsetFromCylinder(cylinderHeight, cone.height, false, true)  # Position on bottom
	#its at the bottom but still facing up
	#rotate_object_local takes a Vec3 that just says 0/1 what axis to target and radians for sopme reason so just deg to rads and -deg for down
	cone.rotate_object_local(Vector3(1,0,0), deg_to_rad(-180))
	#ApplyColorToObject(cone, colorMAGENTA)
	spawnHolderNode.add_child(cone)

	# Create the topBall
	topBall = CSGSphere3D.new()
	topBall.transform.origin = CalculateDffsetFromCylinder(cylinderHeight, topBall.radius, true, false)  # Position at top
	#ApplyColorToObject(topBall, Color.RED)
	spawnHolderNode.add_child(topBall)
	
	#add axis
	var axes = AxesVisualizer.new()
	spawnHolderNode.add_child(axes)
	
	#rotate the holder so it looks closer to the example on spawn
	spawnHolderNode.rotate_object_local(Vector3(0,0,1), deg_to_rad(35))
	
	#init holder vals
	light1XVal = light1.global_transform.origin.x
	light1YVal = light1.global_transform.origin.y
	light1ZVal = light1.global_transform.origin.z
	light2PointVal = rad_to_deg(light2.global_rotation.x)
	
	#connect UI
	penLen.value_changed.connect(OnPenLenChange.bind())
	penWidth.value_changed.connect(OnPenWidthChange.bind())
	penConeLen.value_changed.connect(OnPenConeLenChange.bind())
	light1X.value_changed.connect(OnLight1XChange.bind())
	light1Y.value_changed.connect(OnLight1YChange.bind())
	light1Z.value_changed.connect(OnLight1ZChange.bind())
	light2Point.value_changed.connect(OnLight2PointChange.bind())
	loadNew.pressed.connect(OpenFileDialog.bind())
	
	#init UI vals
	penLen.value = cylinderHeight
	penWidth.value = cylinderWidth
	penConeLen.value = coneHeight
	light1X.value = light1XVal
	light1Y.value = light1YVal
	light1Z.value = light1ZVal
	light2Point.value = light2PointVal
	
	#non-ui sognal management
	#https://github.com/98teg/NativeDialogs/issues/34
	#this gave me working code
	#FOR SOME REASON this will spawn BUT NOT FIRE signals unless I spawn it like this
	#no clue
	nativeDialog.file_mode = NativeFileDialog.FILE_MODE_OPEN_FILE
	nativeDialog.access =NativeFileDialog.ACCESS_FILESYSTEM
	nativeDialog.add_filter("*.png, *.jpg")
	nativeDialog.file_selected.connect(ReadFromFileAndSet)
	self.add_child(nativeDialog)
	#nativeDialog.show()
	
func _process(delta: float) -> void:
	#performance? never heard of it
	#this is beyond catastrophically bad, but i want real time updates
	penLenDebug.text = str(cylinder.height)
	penWidthDebug.text = str(cylinder.radius)
	penConeLenDebug.text = str(cone.height)
	light1XDebug.text = str(light1.global_position.x)
	light1YDebug.text = str(light1.global_position.y)
	light1ZDebug.text = str(light1.global_position.z)
	light2PointDebug.text = str(rad_to_deg(light2.global_rotation.x))

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
	if newH < 0:
		return
	
	#update global
	cylinderHeight = newH
	cylinder.height = cylinderHeight

	#update cone pos
	cone.transform.origin = CalculateDffsetFromCylinder(cylinderHeight, cone.height, false, true)

	#update topBall pos
	topBall.transform.origin = CalculateDffsetFromCylinder(cylinderHeight, topBall.radius, true, false)
	
	
func UpdateCylinderWidth(newW: float):
	if newW < 0:
		return
	
	cylinderWidth = newW
	
	cylinder.radius = cylinderWidth
	cone.radius = cylinderWidth
	topBall.radius = cylinderWidth
	
#signals
func OnPenLenChange(newVal:float) -> void:
	UpdateCylinderHeight(newVal)
	
func OnPenWidthChange(newVal:float) -> void:
	UpdateCylinderWidth(newVal)
	
func OnPenConeLenChange(newVal:float) -> void:
	cone.height = newVal
	cone.transform.origin = CalculateDffsetFromCylinder(cylinderHeight, cone.height, false, true)
	
func OnLight1XChange(newVal:float) -> void:
	light1XVal = newVal
	light1.global_position.x = light1XVal
	
func OnLight1YChange(newVal:float) -> void:
	light1YVal = newVal
	light1.global_position.y = light1YVal

func OnLight1ZChange(newVal:float) -> void:
	light1ZVal = newVal
	light1.global_position.z = light1ZVal
	
func OnLight2PointChange(newVal:float) -> void:
	light2PointVal = deg_to_rad(newVal)
	light2.global_rotation.x = light2PointVal

func OpenFileDialog() -> void:
	nativeDialog.show()
	
func ReadFromFileAndSet(path:String) -> void:
	var fileData = FileManagement.LoadFromFile(path)
	fileData = fileData.split("\n")
	print(fileData)
	
	#there is no fancy file format, just raw data
	#val meanings in row
	#1-PenLen,2-PenWidth,3-PenConeLen,4-Light1X,5-Light1Y,6-Light1Z,7-Light2PointDegrees
	
	if fileData.size() < 7:
		print("Ïnvalid size")
		return
	
	#godot doesnt have try/catch and i cant aggressively fail :(
	var validFloats = []
	for i in fileData:
		if str(i).is_valid_float():
			validFloats.append(i.to_float())
		else:
			print("supplied invalid data")
			return
	print(validFloats)
	
	OnPenLenChange(validFloats[0])
	penLen.value = validFloats[0]
	OnPenWidthChange(validFloats[1])
	penWidth.value = validFloats[1]
	OnPenConeLenChange(validFloats[2])
	penConeLen.value = validFloats[2]
	OnLight1XChange(validFloats[3])
	light1X.value = validFloats[3]
	OnLight1YChange(validFloats[4])
	light1Y.value = validFloats[4]
	OnLight1ZChange(validFloats[5])
	light1Z.value = validFloats[5]
	OnLight2PointChange(validFloats[6])
	light2Point.value = validFloats[6]
	#this is catastrophically bad but it doesnt need to be more complex
