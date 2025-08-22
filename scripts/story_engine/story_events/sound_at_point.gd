class_name SoundAtPoint
extends StoryEvent

@export var sound : AudioStream
@export var point : NodePath

func execute(engine: StoryEngine, world: Dictionary) -> void:
    super.execute(engine, world)
    
    var player := AudioStreamPlayer3D.new()
    player.position = engine.get_node(point).global_position
    player.finished.connect(func(): player.queue_free())
    engine.add_child(player)
    player.stream = sound
    player.play()
