extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


onready var _music_animationPlayer = self.find_node("AnimationPlayer")
onready var _music_animationPlayer2 = self.find_node("AnimationPlayer2")
onready var _sfx_animationPlayer = self.find_node("SFX_AnimationPlayer")
onready var _music_audioStreamPlayer = self.find_node("Music_AudioStreamPlayer")
onready var _music_audioStreamPlayer2 = self.find_node("Music_AudioStreamPlayer2")
onready var _sfx_audioStreamPlayer = self.find_node("SFX_AudioStreamPlayer")
onready var _sfx_audioStreamPlayer2 = self.find_node("SFX_AudioStreamPlayer2")
onready var _sfx_audioStreamPlayer2D = get_owner().find_node("SFX_AudioStreamPlayer2D")

var music_switch = true
var sfx_switch = true

func play_music(music) :
	
	if music_switch:
		if fade_in_music(music):
			stop_music2()
			music_switch = false
	else:
		if fade_in_music2(music):
			stop_music()
			music_switch = true

func fade_in_music(music) -> bool:
	if _music_audioStreamPlayer2.stream != null:
		if _music_audioStreamPlayer2.stream.resource_path == "res://Audio/Music/" + music:
			return false
	
	_music_audioStreamPlayer.stream = load("res://Audio/Music/" + music)
	_music_audioStreamPlayer.volume_db = -100
	_music_audioStreamPlayer.play()
	_music_animationPlayer.play("Music_FadeIn")
	return true
	
func fade_in_music2(music) -> bool:
	if _music_audioStreamPlayer.stream != null:
		if _music_audioStreamPlayer.stream.resource_path == "res://Audio/Music/" + music:
			return false
			
	_music_audioStreamPlayer2.stream = load("res://Audio/Music/" + music)
	_music_audioStreamPlayer2.volume_db = -100
	_music_audioStreamPlayer2.play()
	_music_animationPlayer2.play("Music_FadeIn")
	return true

func stop_music() :
	_music_animationPlayer.play("Music_FadeOut")
func stop_music2() :
	_music_animationPlayer2.play("Music_FadeOut")


func play_SFX(sfx) :
	if sfx_switch:
		play_sound(sfx)
		sfx_switch = false
	else:
		play_sound2(sfx)
		sfx_switch = true

func play_sound(sfx) :
	if (_sfx_audioStreamPlayer.stream_paused == true) :
		_sfx_audioStreamPlayer.stream_paused = false
	_sfx_audioStreamPlayer.stream = load("res://Audio/SFX/" + sfx)
	_sfx_audioStreamPlayer.play()

func play_sound2(sfx) :
	if (_sfx_audioStreamPlayer2.stream_paused == true) :
		_sfx_audioStreamPlayer2.stream_paused = false
	_sfx_audioStreamPlayer2.stream = load("res://Audio/SFX/" + sfx)
	_sfx_audioStreamPlayer2.play()

func stop_SFX() :
	_sfx_audioStreamPlayer.stream_paused = true

func play_SFX2D(sfx) :
	if (_sfx_audioStreamPlayer2D.stream_paused == true) :
		_sfx_audioStreamPlayer2D.stream_paused = false
	_sfx_audioStreamPlayer2D.stream = load("res://Audio/SFX/" + sfx)
	_sfx_audioStreamPlayer2D.play()

func _on_Music_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "Music_FadeOut" || anim_name == "long_fadeout"):
		_music_audioStreamPlayer.stream = load("")
		# _music_audioStreamPlayer.stream = null
		# _music_audioStreamPlayer.stream_paused = true
		# _music_audioStreamPlayer.stop() # music is faded out so stop playing it
		_music_animationPlayer.play("Music_Init") # this resets the music volume to original so that next song played will have volume

func play_long_fade():
	_sfx_animationPlayer.play("long_fadeout")
	if (music_switch):
		_music_animationPlayer2.play("long_fadeout")
	else:
		_music_animationPlayer.play("long_fadeout")

