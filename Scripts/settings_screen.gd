extends Control
class_name SettingsScreen


@export var music_menu: MenuButton
@export var sfx_slider: Range
@export var music_slider: Range
var music_popup: PopupMenu
var hint_sound: AudioStreamPlayer

signal close_menu


func _ready() -> void:
	if not music_menu: return;
	music_popup = music_menu.get_popup()
	for music_set_name in AudioPlayer.music:
		music_popup.add_item(music_set_name);
	music_popup.connect("id_pressed", popup_selected);
	music_menu.text = AudioPlayer.default_set
	sfx_slider.connect("value_changed", sfx_changed)
	music_slider.connect("value_changed", music_changed)


func popup_selected(id: int):
	var new_set := music_popup.get_item_text(id);
	AudioPlayer.change_audio_set(new_set);
	music_menu.text = new_set


func close_button_pressed():
	close_menu.emit();


func sfx_changed(value: float) -> void:
	AudioPlayer.change_sfx_volume(value)
	if not hint_sound:
		hint_sound = AudioPlayer.play_sfx("blip")


func music_changed(value: float) -> void:
	AudioPlayer.change_music_volume(value)
