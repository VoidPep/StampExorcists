extends Control

@onready var image = $TextureRect
@onready var text = $Label

var current_index := 0
var can_advance := false

var scenes = [
	{
		"image": preload("res://scenes/final_cutscene/images/StampExorcistBossWin1.png"),
		"text": "..."
	},
	{
		"image": preload("res://scenes/final_cutscene/images/StampExorcistBossWin2.png"),
		"text": "Então você conseguiu..."
	},
	{
		"image": preload("res://scenes/final_cutscene/images/StampExorcistBossWin3.png"),
		"text": "O selo em suas costas vai continuar por mais séculos..."
	},
	{
		"image": preload("res://scenes/final_cutscene/images/StampExorcistBossWin4.png"),
		"text": "Mas... Seu trabalho não acabou, tem muito a fazer ainda"
	},
	{
		"image": preload("res://scenes/final_cutscene/images/StampExorcistBossWin4.png"),
		"text": "Obrigado por jogar! Aperte novamente para voltar ao menu :)"
	}
]

func _ready():
	GlobalAudioManager.play_music(GlobalAudioManager.MUSIC_CUTSCENE)
	show_scene()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		next_scene()

func show_scene():
	can_advance = false
	
	image.texture = scenes[current_index]["image"]
	text.text = scenes[current_index]["text"]
	
	await get_tree().create_timer(0.8).timeout
	can_advance = true

func next_scene():
	current_index += 1
	if current_index >= scenes.size():
		go_to_menu()
	else:
		if current_index == scenes.size():
			$ColorRect.visible = false
		show_scene()

func go_to_menu():
	SceneManager.change_scene("res://scenes/main_menu/MainMenu.tscn", image)
