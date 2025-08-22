class_name StoryEventCollection
extends StoryEvent

@export var events : Array[StoryEvent] = []

func execute(engine: StoryEngine, world: Dictionary) -> void:
    super.execute(engine, world)
    
    for event in events:
        event.execute(engine, world)
