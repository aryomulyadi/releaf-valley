extends Node

var equipment: Dictionary[String, EquipData] = {
	"helmet": null,
	"body": null,
	"legs": null,
	"weapon": null,
	"ring": null,
}

var skill_slots: Array[SkillData] = [null, null, null, null]

var coins: float = 500.0
