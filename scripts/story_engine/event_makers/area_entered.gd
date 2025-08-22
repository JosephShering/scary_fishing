class_name AreaEnteredEventTrigger
extends EventTrigger

@export var event : StoryEvent
@export var area : Area3D

func _ready() -> void:
    area.body_entered.connect(_on_entered)
    
    area.monitoring = false
    area.monitorable = false
    
    activated.connect(func():
        area.set_deferred(&"monitoring", true)
    )
    
    deactivated.connect(func():
        area.set_deferred(&"monitoring", false)
    )
    
    super._ready()
    
    
func _on_entered(body: Node) -> void:
    if body is Player:
        story_engine.trigger(event_idx)
