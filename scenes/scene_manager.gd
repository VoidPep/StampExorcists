extends Node

var current_scene: Node
var current_scene_path: String

func _ready():
	current_scene = get_tree().current_scene
	current_scene_path = current_scene.scene_file_path

func change_scene(path: String, tween_node = null):
	if current_scene_path == path:
		return
	
	if tween_node:
		await create_tween().tween_property(tween_node, "modulate:a", 0.0, 0.3).finished
		
	get_tree().change_scene_to_file(path)
	
	await get_tree().process_frame
	
	current_scene = get_tree().current_scene
	current_scene_path = path
