extends Area2D
class_name Enemy

signal on_enemy_died

@export var max_health: float = 10.0
@export var damage: float = 2.0
@export var exp_amount: float = 20.0

@export var loot: Array[LootData]

@onready var selector: Sprite2D = $Selector
@onready var health_component: HealthComponent = $HealthComponent
@onready var anim_sprite: AnimatedSprite2D = $AnimSprite
@onready var health_bar: ProgressBar = $HealthBar
@onready var fsm: FSM = $FSM

var enemy_zone: EnemyZone

func _ready() -> void:
	health_component.setup(max_health)
	health_bar.value = 1.0

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		Refs.player.selected_enemy = self

func _process(delta: float) -> void:
	if fsm.curr_state:
		fsm.curr_state.process_state(delta)

func update_animation(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			anim_sprite.play("move_right")
		else:
			anim_sprite.play("move_left")
	else:
		if dir.y > 0:
			anim_sprite.play("move_down")
		else:
			anim_sprite.play("move_up")

func drop_loot() -> void:
	var random_data: LootData = loot.pick_random()
	var drop_item: DropItem = Refs.DROP_ITEM_SCENE.instantiate()
	
	var away_dir: Vector2 = (global_position - Refs.player.global_position).normalized()
	var drop_pos: Vector2 = global_position + away_dir * 15
	
	drop_item.load_item(random_data)
	drop_item.global_position = drop_pos
	get_tree().root.call_deferred("add_child", drop_item)
	
	on_enemy_died.emit()

func select_enemy() -> void:
	selector.show()

func deselect_enemy() -> void:
	selector.hide()

func _on_detect_area_body_entered(body: Node2D) -> void:
	fsm.transition_to("Follow")

func _on_detect_area_body_exited(body: Node2D) -> void:
	fsm.transition_to("Wander")

func _on_health_component_on_health_changed(curr_health: float) -> void:
	health_bar.value = curr_health / max_health

func _on_health_component_on_dead() -> void:
	drop_loot()
	EventBus.on_quest_progress_updated.emit("enemy_10", 1)
	Refs.player.add_exp(exp_amount)
	queue_free()
