extends Node2D
class_name Town

@export var player_scene: PackedScene

@onready var navigation: TileMapLayer = %Navigation

func _ready() -> void:
	EventBus.on_inventory_used_item.connect(_on_inventory_used_item)
	Refs.navigation = navigation
	create_player()

func create_player() -> void:
	var player: Player = player_scene.instantiate()
	add_child(player)
	player.setup()
	Refs.player = player
	EventBus.on_player_created.emit()

func _on_inventory_used_item(item: ItemData) -> void:
	match item.id:
		"hp_potion": Refs.player.health_component.heal(item.value)
		"mana_potion": Refs.player.add_mana(item.value)
