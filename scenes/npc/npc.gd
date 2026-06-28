extends Area2D
class_name NPC

enum NPCType {
	IDLE,
	SHOP,
	QUEST,
	CRAFTING
}

@export var type: NPCType
@export var dialogue: DialogueData

@export_group("Movement")
@export var can_move: bool
@export var move_speed: float = 30.0
@export var wait_time: float = 3.0

@onready var anim_sprite: AnimatedSprite2D = $AnimSprite
@onready var nav_agent: NavigationAgent2D = $NavAgent
@onready var timer: Timer = $Timer

var last_direction: String = "down"

func _ready() -> void:
	if not can_move:
		return
	
	await get_tree().process_frame
	set_new_target()

func _process(delta: float) -> void:
	if not can_move:
		return
	
	if is_waiting_for_next_move():
		play_animation("idle")
		return
	
	if has_reached_target():
		if timer.is_stopped():
			timer.start(wait_time)
		return
	
	var next_path_pos: Vector2 = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	global_position += direction * move_speed * delta
	update_direction(direction)
	play_animation("move")

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if dialogue:
			EventBus.on_dialogue_started.emit(dialogue)
			if type != NPCType.IDLE:
				await EventBus.on_dialogue_finished
				Refs.hud.open_npc_panel(type)
		else:
			if type != NPCType.IDLE:
				Refs.hud.open_npc_panel(type)

func set_new_target() -> void:
	if not Refs.navigation:
		return
	
	var used_cells: Array[Vector2i] = Refs.navigation.get_used_cells()
	if used_cells.is_empty():
		return
	
	var random_cell: Vector2i = used_cells.pick_random()
	var world_pos: Vector2 = Refs.navigation.to_global(Refs.navigation.map_to_local(random_cell))
	
	nav_agent.target_position = world_pos

func is_waiting_for_next_move() -> bool:
	return not timer.is_stopped()

func has_reached_target() -> bool:
	return nav_agent.is_navigation_finished()

func play_animation(anim: String) -> void:
	anim_sprite.play("%s_%s" % [anim, last_direction])

func update_direction(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		last_direction = "right" if dir.x > 0 else "left"
	else:
		last_direction = "down" if dir.y > 0 else "up"

func _on_timer_timeout() -> void:
	set_new_target()
