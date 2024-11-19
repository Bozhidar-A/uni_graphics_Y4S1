extends Node


func SaveToFile(content):
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_string(content)

func LoadFromFile():
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	var content = file.get_as_text()
	return content

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.mode = FileDialog.FILE_MODE_OPEN_FILE
	self.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	self.filters = ["*.txt"]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
