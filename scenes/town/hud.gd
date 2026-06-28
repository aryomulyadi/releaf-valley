extends CanvasLayer
class_name HUD

@export var skill_buttons: Array[EquippedSkillButton]

@onready var equipment_panel: EquipmentPanel = %EquipmentPanel
@onready var inventory_panel: InventoryPanel = %InventoryPanel
@onready var stats_panel: StatsPanel = %StatsPanel
@onready var skills_panel: SkillPanel = %SkillsPanel

@onready var shop_panel: Control = $ShopPanel
@onready var craft_panel: CraftPanel = $CraftPanel
@onready var quest_panel: QuestPanel = $QuestPanel

@onready var health_bar: ProgressBar = $HealthBar
@onready var mana_bar: ProgressBar = $ManaBar
@onready var exp_bar: ProgressBar = $ExpBar

@onready var health_label: Label = %HealthLabel
@onready var mana_label: Label = %ManaLabel

func _ready() -> void:
	Refs.hud = self
	EventBus.on_player_health_updated.connect(_on_player_health_updated)
	EventBus.on_player_mana_updated.connect(_on_player_mana_updated)
	EventBus.on_player_new_level.connect(_on_player_new_level)
	disable_all_button_focus(self)

func disable_all_button_focus(node: Node) -> void:
	if node is Button:
		node.focus_mode = Control.FOCUS_NONE
	for child in node.get_children():
		disable_all_button_focus(child)

func open_npc_panel(type: NPC.NPCType) -> void:
	match type:
		NPC.NPCType.SHOP:
			shop_panel.show()
		NPC.NPCType.CRAFTING:
			craft_panel.show()
		NPC.NPCType.QUEST:
			quest_panel.show()

func equip_skill_to_empty_slot(skill: SkillData) -> void:
	for i in skill_buttons.size():
		var button: EquippedSkillButton = skill_buttons[i]
		if button.equipped_data == null:
			button.equip_skill(skill)
			GameData.skill_slots[i] = skill
			return

func _on_equipment_button_pressed() -> void:
	equipment_panel.visible = not equipment_panel.visible
	SoundManager.play(Sound.BUTTON)

func _on_inventory_button_pressed() -> void:
	inventory_panel.visible = not inventory_panel.visible
	SoundManager.play(Sound.BUTTON)

func _on_stats_button_pressed() -> void:
	stats_panel.visible = not stats_panel.visible
	SoundManager.play(Sound.BUTTON)

func _on_skills_button_pressed() -> void:
	skills_panel.visible = not skills_panel.visible
	SoundManager.play(Sound.BUTTON)

func _on_player_health_updated(curr: float, max: float) -> void:
	health_bar.value = curr / max
	health_label.text = "%d / %d" % [curr, max]

func _on_player_mana_updated(curr: float, max: float) -> void:
	mana_bar.value = curr / max
	mana_label.text = "%d / %d" % [curr, max]

func _on_player_new_level(curr: float, new_level: float) -> void:
	exp_bar.value = curr / new_level
