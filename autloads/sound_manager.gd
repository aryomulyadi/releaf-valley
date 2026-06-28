extends Node

var sound_dic: Dictionary = {
	Sound.BUTTON: preload("uid://dbpta8vftvucu"),
	Sound.IMPACT: preload("uid://hoishduykjq3"),
	Sound.SKILL_HIT: preload("uid://dtpc6gb6vrixo"),
	Sound.PICKUP: preload("uid://vyv1wcfafpsd")
}

@export var stream_players: Array[AudioStreamPlayer]

func play(type: int) -> void:
	var stream_pla = get_free_stream_player()
	if not stream_pla:
		return
	
	var audio = sound_dic[type]
	stream_pla.stream = audio
	stream_pla.pitch_scale = randf_range(0.8, 1.2)
	stream_pla.play()


func get_free_stream_player() -> AudioStreamPlayer:
	for stream in stream_players:
		if not stream.playing:
			return stream
	return null
