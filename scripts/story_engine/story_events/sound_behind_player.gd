class_name SoundBehindPlayer
extends StoryEvent

@export var sound : AudioStream
@export var distance : float = 1.0

func execute(engine: StoryEngine, world: Dictionary) -> void:
    super.execute(engine, world)
    
    var player := AudioStreamPlayer3D.new()
    player.finished.connect(func(): player.queue_free())
    engine.get_tree().current_scene.add_child(player)
    player.position = world["player_position"] + (-world["player_forward"] * distance)
    player.stream = sound
    player.play()
