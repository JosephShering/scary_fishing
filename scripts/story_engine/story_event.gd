class_name StoryEvent
extends Resource

@export var name := ""
@export var delay := 0.0

func condition_met(_world: Dictionary) -> bool:
    return true

func execute(story_engine: StoryEngine, _world: Dictionary) -> void:
    await Engine.get_main_loop().create_timer(delay).timeout
