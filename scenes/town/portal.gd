extends Area2D
class_name Portal

@export var target_pos: Node2D

func _on_body_entered(body: Node2D) -> void:
	await Transition.fade_in(1.0)
	Refs.player.global_position = target_pos.global_position
	Transition.fade_out(1.0)
