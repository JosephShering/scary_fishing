class_name EventTrigger
extends Node

signal activated
signal deactivated

@export var story_engine : StoryEngine
@export var event_idx : int = 0

func _ready() -> void:
    story_engine.triggered.connect(_on_triggered)
    
    if event_idx == 0:
        activated.emit()
    
func _on_triggered(idx: int, _event) -> void:
    if idx + 1 == event_idx:
        activated.emit()
        
    if idx == event_idx:
        deactivated.emit()
