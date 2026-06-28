extends Node

signal on_player_created
signal on_player_health_updated(curr: float, max: float)
signal on_player_mana_updated(curr: float, max: float)

signal on_player_new_level(curr: float, new_level: float)
signal on_player_stats_updated

signal on_inventory_used_item(item: ItemData)

signal on_dialogue_started(data: DialogueData)
signal on_dialogue_finished

signal on_quest_progress_updated(quest_id: String, amount: int)
