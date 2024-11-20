#this is a script thats globally loaded
#why does it need to inherit Node?
#https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
extends Node

func LoadFromFile(filePath: String):
	var file = FileAccess.open(filePath, FileAccess.READ)
	var content = file.get_as_text(true)
	return content
