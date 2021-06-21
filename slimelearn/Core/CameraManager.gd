extends Node2D

const dim = 14
var screen: Array

func _ready():
	pass

# warning-ignore:unused_argument
func _process(delta):
	if Global.Player != null and Global.Player.is_inside_tree():
		self.global_position.y = Global.Player.global_position.y
	
	_take_images()
	_see()
	_distance_walls()
	
#Get screen as photos
func _take_images():
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	
	image.lock()
	var binary_array = []
	var size = image.get_size()
	
	for y in size.y:
		var row = []
		for x in size.x:
			var pixel_gray = image.get_pixel(x, y).v
			if pixel_gray > 0:
				row.append(1)
			else:
				row.append(0)
		binary_array.append(row)
	image.unlock()
	
	Interpreter.packet_factory("resolution", null, size)
	Interpreter.packet_factory("screen", null, binary_array)

#Simulates basic sight
#TODO: Add horizontal distance to the walls
func _see():
	var platforms = []
	var detectable_objects = ["Platform", "Rock", "Money"]
	for object in get_parent().get_node("SimpleMap").get_children():
		var object_children = object.get_children()
		
		for type in detectable_objects:
			if type in object.name:
				var object_info = {}
				object_info["name"] = object.name
				object_info["type"] = type
				object_info["x"] = object.global_position.x
				object_info["y"] = object.global_position.y
				platforms.append(object_info)
				
			if object_children != null:
				for child in object_children:
					if type in child.name:
						var object_info = {}
						object_info["name"] = object.name
						object_info["type"] = type
						object_info["x"] = object.global_position.x
						object_info["y"] = object.global_position.y
						platforms.append(object_info)
				
	Interpreter.packet_factory("sight", null, platforms)
	
#Measures the distance to the walls
func _distance_walls():
	if Global.Player.is_inside_tree():
		Interpreter.packet_factory("limits", "right", (104 - 6) - Global.Player.global_position.x)
		Interpreter.packet_factory("limits", "left", Global.Player.global_position.x - 14)

