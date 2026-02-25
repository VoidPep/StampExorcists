extends Control

@onready var image = $TextureRect
@onready var text = $Label

var current_index := 0
var can_advance := false

var scenes = [
	{
		"image": preload("res://scenes/initial_cutscene/images/StampExorcistIntro1.png"),
		"text": "Desde anos...\nLogo acima do topo das nuvens..."
	},
	{
		"image": preload("res://scenes/initial_cutscene/images/StampExorcistIntro2.png"),
		"text": "Os selos antigos acabam por enfraquecer...\nE eles retornam"
	},
	{
		"image": preload("res://scenes/initial_cutscene/images/StampExorcistIntro3.png"),
		"text": "Gravado em tinta a missão é mantida..."
	},
	{
		"image": preload("res://scenes/initial_cutscene/images/StampExorcistIntro4.png"),
		"text": "Eles não pertencem a esse mundo...\nE alguém precisava carimbá-los da eternidade...\n"
	},
	{
		"image": preload("res://scenes/initial_cutscene/images/StampExorcistIntro5.png"),
		"text": "E assim nasceram os carimbadores...\nUma espécie antiga de humanos capazes de selar essas criaturas"
	},
	{
		"image": preload("res://scenes/initial_cutscene/images/StampExorcistIntro6.png"),
		"text": "O usuário carimba\nO Martelo sela"
	},
	{
		"image": preload("res://scenes/initial_cutscene/images/StampExorcistIntro7.png"),
		"text": "E este é você...\nTalvez um dos últimos... Exorcistas do carimbo"
	},
	{
		"image": preload("res://scenes/initial_cutscene/images/StampExorcistIntro8.png"),
		"text": ""
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
		start_game()
	else:
		if current_index == scenes.size() -1:
			$ColorRect.visible = false
		show_scene()

func start_game():
	SceneManager.change_scene("res://scenes/tiles/game_test.tscn", image)
