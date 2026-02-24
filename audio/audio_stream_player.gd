extends Node

var music_player: AudioStreamPlayer
var sfx_players: Array = []

const DASH = preload("res://audio/sfx/dash.wav")
const ENEMY_DEATH = preload("res://audio/sfx/enemy_death.wav")
const GROUND_POUND = preload("res://audio/sfx/ground_pound.wav")
const HIT = preload("res://audio/sfx/hit_slide.wav")
const SWING = preload("res://audio/sfx/swing.wav")
const WALK = [
	preload("res://audio/sfx/walk_1.wav"),
	preload("res://audio/sfx/walk_2.wav"),
	preload("res://audio/sfx/walk_3.wav"),
	preload("res://audio/sfx/walk_4.wav")
]

const MUSIC_MENU = preload("res://audio/musics/menu.wav")
const MUSIC_CUTSCENE = preload("res://audio/musics/cutscene.wav")
const MUSIC_COMBAT = preload("res://audio/musics/combat.wav")

func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)

func play_music(stream: AudioStream, volume_db: float = 0.0):
	if music_player.stream == stream:
		return
		
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -40, 0.3)
	await tween.finished
		
	music_player.autoplay = true
	music_player.stream = stream
	music_player.volume_db = volume_db
	music_player.play()
	
	var tween2 = create_tween()
	tween2.tween_property(music_player, "volume_db", 0, 0.3)

func stop_music():
	music_player.stop()

func play_sfx(stream: AudioStream, volume_db: float = 0.0):
	var player = AudioStreamPlayer.new()
	
	player.pitch_scale = randf_range(0.95, 1.05)
	player.stream = stream
	player.volume_db = volume_db
	player.bus = "SFX"
	add_child(player)
	
	player.play()
	player.finished.connect(player.queue_free)
	
func play_random_sfx(streams: Array, volume_db: float = 0.0):
	if streams.is_empty():
		return
		
	var random_stream = streams.pick_random()
	
	play_sfx(random_stream, volume_db)
