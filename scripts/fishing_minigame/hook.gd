class_name Hook
extends RigidBody2D

signal fish_hooked(body: Node)

@export var sprite : Sprite2D
@export var right_collision_shape : CollisionShape2D
@export var left_collision_shape : CollisionShape2D
@export var area : Area2D

var is_hooked := false

func _ready() -> void:
    area.body_entered.connect(func(fish):
        is_hooked = true
        fish_hooked.emit(fish)    
    )

func _physics_process(delta: float) -> void:
    if is_hooked:
        return
        
    if linear_velocity.x < 0.0 or angular_velocity < 0.0:
        sprite.flip_h = false
        sprite.offset = Vector2(
            -43.915,
            0.0
        )
        left_collision_shape.disabled = false
        right_collision_shape.disabled = true
    else:
        sprite.flip_h = true
        sprite.offset = Vector2.ZERO
        left_collision_shape.disabled = true
        right_collision_shape.disabled = false
