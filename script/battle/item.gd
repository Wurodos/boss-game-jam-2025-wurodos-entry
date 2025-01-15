extends Resource

class_name Item

enum Type{HAT, WEAPON, TRINKET, NO_ITEM}

@export var name : String
@export var desc : String
@export var type : Type
@export var sprite : Texture2D
@export var effects : Dictionary

func _init() -> void:
	name = ""
	type = Type.NO_ITEM
	sprite = null

func clone() -> Item:
	var copy = Item.new()
	copy.name = self.name
	copy.desc = self.desc
	copy.sprite = self.sprite
	copy.type = self.type
	copy.effects = self.effects
	return copy

func has_action() -> bool:
	return (effects.keys().has("DMG") 
	or effects.keys().has("HEAL"))
