extends CanvasLayer
class_name HUD

@export var player: Player

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var health_bar_fill: ColorRect = $HealthBar/Bar

var fill_max_width: float

func _ready():
	if not player:
		return

	fill_max_width = health_bar_fill.size.x

	health_bar.max_value = Player.MAX_HP
	health_bar.value = Player.MAX_HP

func _on_hp_changed(current: int, max_hp: int):
	if not health_bar_fill:
		return
	
	var percent = float(current) / float(max_hp)
	health_bar_fill.size.x = fill_max_width * percent
