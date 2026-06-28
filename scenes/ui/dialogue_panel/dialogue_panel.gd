extends Control
class_name DialoguePanel

@onready var npc_icon: TextureRect = $NPCIcon
@onready var dialogue_label: Label = %DialogueLabel

var curr_dialogue: DialogueData
var curr_line_index: int = 0
var typing_speed: float = 0.03
var is_typing: bool
var tween: Tween

func _ready() -> void:
	hide()
	EventBus.on_dialogue_started.connect(_on_dialogue_started)

func _input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("ui_accept") or \
	event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		
		if is_typing:
			complete_line()
		else:
			next_line()
		

func _on_dialogue_started(data: DialogueData) -> void:
	curr_dialogue = data
	curr_line_index = 0
	npc_icon.texture = data.npc_icon
	show()
	show_line()

func show_line() -> void:
	if curr_line_index >= curr_dialogue.line.size():
		end_dialogue()
		return
	
	var line: String = curr_dialogue.line[curr_line_index]
	dialogue_label.text = curr_dialogue.npc_name + ":\n" + line
	
	dialogue_label.visible_characters = 0
	is_typing = true
	
	if tween:
		tween.kill()
	tween = create_tween()
	
	var duration = dialogue_label.text.length() * typing_speed
	tween.tween_property(dialogue_label, "visible_characters", dialogue_label.text.length(), duration)
	tween.finished.connect(func(): is_typing = false)

func complete_line() -> void:
	if tween:
		tween.kill()
	dialogue_label.visible_characters = -1
	is_typing = false

func next_line() -> void:
	curr_line_index += 1
	show_line()

func end_dialogue() -> void:
	hide()
	curr_dialogue = null
	EventBus.on_dialogue_finished.emit()
