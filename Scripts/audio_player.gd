extends Node

@export var volume: float = 0;

@onready var bg_music = $MusicPlayer

enum SCENE_SET {MENU, LEVEL}
var current_scene = SCENE_SET.MENU

var powerUp = preload("res://Assets/Sounds/Effects/powerUp.wav")
var pickupOre = preload("res://Assets/Sounds/Effects/pickupOre.wav")
var explosion = preload("res://Assets/Sounds/Effects/explosion.wav")
var explosion2 = preload("res://Assets/Sounds/Effects/explosion2.wav")
var dig = preload("res://Assets/Sounds/Effects/dig.wav")
var nonBreak = preload("res://Assets/Sounds/Effects/nonBreak.wav")

var menu = preload("res://Assets/Sounds/Music/GameJam_Depth-Menu_Mix1.1_M1.0.mp3")
var level = preload("res://Assets/Sounds/Music/GameJam_Depth_Mix1.0_M1.0.mp3")

func play_sfx(sfx_name: String):
	var stream = null
	if sfx_name == "powerUp":
		stream = powerUp
	elif sfx_name == "pickupOre":
		stream = pickupOre
	elif sfx_name == "dig":
		stream = dig
	elif sfx_name == "explosion":
		if randf()>0.05:
			stream = explosion
		else:
			stream = explosion2
	elif sfx_name == "nonBreak":
		stream = nonBreak
	else:
		#print("Invalid sfx name")
		return
	
	var asp = AudioStreamPlayer.new()
	asp.volume_db = volume
	asp.stream = stream
	asp.name = "SFX-"+sfx_name
	
	add_child(asp)
	
	asp.play()
	await asp.finished
	asp.queue_free()

func change_music(scene: int):
	if current_scene != scene:
		if scene == SCENE_SET.MENU:
			bg_music.stream = menu
		elif scene == SCENE_SET.LEVEL:
			bg_music.stream = level
		bg_music.play()
		current_scene = scene
