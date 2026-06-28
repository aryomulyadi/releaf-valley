extends Button
class_name ShopButton

signal on_item_purchased

@onready var item_icon: TextureRect = $ItemIcon
@onready var price: Label = %Price

var item: ItemData

func load_item(data: ItemData) -> void:
	item = data
	item_icon.texture = data.icon
	price.text = str(data.price)

func _on_pressed() -> void:
	if GameData.coins < item.price:
		return
	
	GameData.coins -= item.price
	Inventory.add_item(item)
	on_item_purchased.emit()
