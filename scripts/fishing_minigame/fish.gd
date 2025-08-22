class_name Fish
extends AnimatableBody2D

@export var path_follow : PathFollow2D
@export var sprite : Sprite2D

var time := 0.0
var magnitude := 10.0
var speed := 0.1

var spawn_position := Vector2.ZERO

var _speed := Vector2.ZERO

func _ready() -> void:
    spawn_position = position

func _physics_process(delta: float) -> void:
    if path_follow != null:
        path_follow.progress_ratio += delta * speed
        
        _speed = (path_follow.global_position - global_position)
        global_position = path_follow.global_position
        
    if _speed.x < 0.0:
        sprite.flip_h = true
    else:
        sprite.flip_h = false
