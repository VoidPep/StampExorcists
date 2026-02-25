extends CanvasLayer

@onready var button := $Control/CenterContainer/VBoxContainer/Button

func _ready():
	visible = false
	layer = 10
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.player_died.connect(show_game_over)
		
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	
func show_game_over():
	visible = true
	$Control.modulate.a = 0
	var tween = create_tween()
	tween.tween_property($Control, "modulate:a", 1.0, 0.8)

func _on_retry_button_pressed() -> void:
	SceneManager.reload_current_scene()
