class_name SpawnSceneBehindPlayer
extends StoryEvent

@export_file var scene : String

var _packed_scene : PackedScene

func _init() -> void:
    _packed_scene = load(scene)

func execute(engine: StoryEngine, world: Dictionary) -> void:
    engine.get_tree().current_scene.add_child(_packed_scene.instantiate())
    
