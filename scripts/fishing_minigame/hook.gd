class_name Hook
extends RigidBody2D

signal fish_touched(body: Node)

func _ready() -> void:
    body_entered.connect(_body_entered)

func _body_entered(body: Node) -> void:
    if body.is_in_group(&"fishes"):
        fish_touched.emit(body)
