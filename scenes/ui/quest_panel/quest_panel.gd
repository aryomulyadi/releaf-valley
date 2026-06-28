extends Control
class_name QuestPanel

@export var quests: Array[QuestData]

@onready var container: VBoxContainer = %Container

func _ready() -> void:
	for button in container.get_children():
		button.queue_free()
	create_quest_buttons()

func create_quest_buttons() -> void:
	for quest: QuestData in quests:
		var btn: QuestButton = Refs.QUEST_BUTTON_SCENE.instantiate()
		container.add_child(btn)
		btn.setup(quest)

func _on_close_button_pressed() -> void:
	hide()
