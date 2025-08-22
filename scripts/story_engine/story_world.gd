class_name StoryWorld
extends Node

var world := {}

@export var player : Player

func _physics_process(_delta: float) -> void:
    world = {
        player_position = player.global_position,
        player_forward = -player.global_basis.z
    }
