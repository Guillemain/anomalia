extends AudioStreamPlayer
class_name audio_effect

@export var audio_clips : Array[AudioStream]

@export var pitch_distortion := 0.0 
@export var looping := false
var _real_pitch := 1.0
func play_sound():
	if(len(audio_clips)<1):
		return
	var idx = randi_range(0,len(audio_clips)-1)
	stream = audio_clips[idx]
	pitch_scale = randf_range(_real_pitch-pitch_distortion,_real_pitch+pitch_distortion+0.001)
	stream_paused = true
	playing = true
	
func _ready():
	if(looping):
		finished.connect(play_sound)
	_real_pitch = pitch_scale
	
func stop_play():
#	playing = false
	print("stop")
	stream_paused = false
	playing = false

func set_volume(db):
	volume_db = db
