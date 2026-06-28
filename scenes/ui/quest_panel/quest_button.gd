extends Button
class_name QuestButton

@onready var quest_name: Label = %QuestName
@onready var quest_description: Label = %QuestDescription
@onready var item_icon: TextureRect = %ItemIcon
@onready var quest_progress: Label = %QuestProgress

var quest_data: QuestData
var curr_progress: int = 0

func _ready() -> void:
	EventBus.on_quest_progress_updated.connect(_on_quest_progress_updated)

func setup(data: QuestData) -> void:
	quest_data = data
	quest_name.text = data.quest_name
	quest_description.text = data.quest_descrip
	item_icon.texture = data.quest_item_reward.icon
	update_progress_label()

func update_progress_label() -> void:
	if curr_progress >= quest_data.quest_target_value:
		curr_progress = quest_data.quest_target_value
		self_modulate = Color.GREEN
	
	quest_progress.text = "%s / %s" % [curr_progress, quest_data.quest_target_value]

func _on_quest_progress_updated(quest_id: String, amount: int) -> void:
	if quest_data and quest_data.quest_id == quest_id:
		if curr_progress < quest_data.quest_target_value:
			curr_progress += amount
			update_progress_label()

func _on_pressed() -> void:
	if curr_progress >= quest_data.quest_target_value:
		Inventory.add_item(quest_data.quest_item_reward)
		SoundManager.play(Sound.BUTTON)
		queue_free()
