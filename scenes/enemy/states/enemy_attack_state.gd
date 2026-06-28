extends EnemyState
class_name EnemyAttackState

@export var attack_duration := 0.5

var attack_timer := 0.0
var damage_applied := false

func enter_state() -> void:
	attack_timer = attack_duration
	damage_applied = false

func process_state(delta: float) -> void:
	if not enemy or not Refs.player:
		fsm.transition_to("Wander")
		return
	
	attack_timer -= delta
	if attack_timer <= attack_duration / 2.0 and not damage_applied:
		apply_damage()
		damage_applied = true
	
	if attack_timer <= 0.0:
		fsm.transition_to("Follow")

func apply_damage() -> void:
	var dist = enemy.global_position.distance_to(Refs.player.global_position)
	if dist <= 25.0:
		Refs.player.health_component.take_damage(enemy.damage)
		Refs.create_damage_fx(Refs.player.global_position)
		Refs.create_damage_text(Refs.player.global_position, enemy.damage)
		SoundManager.play(Sound.IMPACT)
