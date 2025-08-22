extends Node2D

signal fish_caught

@export var fishing_line : FishingLine

func _ready() -> void:
    fishing_line.fish_hooked.connect(fish_caught.emit)
