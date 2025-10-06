extends AudioStreamPlayer

#@export var volume: float = 0;
@export var sfx: Dictionary[String, AudioSet]
@export var music: Dictionary[String, AudioSet]
@export var default_set: String

var current_music : String
var volume: float = 0
@onready var current_sfx_set: AudioSet = sfx[default_set]
@onready var current_music_set: AudioSet = music[default_set]


func change_audio_set(audio_set_name: String) -> void:
	if sfx.has(audio_set_name):
		current_sfx_set = sfx[audio_set_name];
	if music.has(audio_set_name):
		current_music_set = music[audio_set_name];
		var temp_music := current_music
		current_music = "";
		change_music(temp_music)


func change_sfx_volume(new_volume: float) -> void:
	volume = new_volume;


func change_music_volume(new_volume: float) -> void:
	volume_db = new_volume;


func play_sfx(sfx_name: String) -> AudioStreamPlayer:
	if not current_sfx_set.audio_set.has(sfx_name): return null;
	var sfx_stream := current_sfx_set.audio_set[sfx_name]
	
	var asp := AudioStreamPlayer.new()
	asp.volume_db = volume
	asp.stream = sfx_stream
	asp.name = "SFX-"+sfx_name
	
	add_child(asp)
	
	asp.play()
	queue_free_on_finished(asp)
	return asp


func queue_free_on_finished(asp: AudioStreamPlayer):
	await asp.finished
	asp.queue_free()


func change_music(music_name: String):
	if current_music == music_name: return
	if not current_music_set.audio_set.has(music_name): return
	stream = current_music_set.audio_set[music_name];
	play();
	current_music = music_name
