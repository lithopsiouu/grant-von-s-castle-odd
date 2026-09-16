class_name Item extends Node

## Base Item class. Only contains fields for [param icon], [param title], and [param lore].

@export var icon: CompressedTexture2D
@export var title: String = "Item" ## Title of this item.
@export var lore: String = "Description" ## A short description of this item.
