class_name Player
extends SimpleFPSCharacter

const FREE_WALK := "FREE_WALK"
const FISHING := "FISHING"

const GAME = preload("res://scenes/fishing_minigame/fishing_minigame.tscn")

signal fishing_start()
signal fishing_end()

@export var footstep_timer : Timer
@export var footstep_player : AudioStreamPlayer
@export var canvas_layer : CanvasLayer


var footstep_sounds := [
    preload("res://assets/sounds/footsteps/step2.wav"),
    preload("res://assets/sounds/footsteps/step3.wav")
]

var fishing_base_speed := 30.0
var _ground_base_speed := 0.0

var _fishing_game

var sm := SM.new()

func _ready() -> void:
    super._ready()
    
    var fishing := State.new() \
    .on_enter(_on_fishing) \
    .on_exit(_fishing_exit)
    
    var free_walk := State.new() \
    .on_enter(_on_free_walk) \
    .on_tick(_free_walk_tick) \
    .on_exit(_on_free_walk_exit)
    
    sm.add(FISHING, fishing)
    sm.add(FREE_WALK, free_walk)
    sm.initial_state(FREE_WALK)

    footstep_timer.timeout.connect(_on_footstep_timeout)
    _ground_base_speed = ground_base_speed

func _on_footstep_timeout() -> void:
    footstep_player.stream = footstep_sounds.pick_random()
    footstep_player.play()

func _physics_process(delta: float) -> void:
    sm.tick(delta)
    
func _on_fishing() -> void:
    footstep_timer.stop()
    
    _ground_base_speed = ground_base_speed
    ground_base_speed = fishing_base_speed
    input.mouse_look_input = Vector2.ZERO
    
    rotation_behavior = RotationBehavior.look_at
    
    _fishing_game = GAME.instantiate()
    canvas_layer.add_child(_fishing_game)
    _fishing_game.fish_caught.connect(_on_fish_caught)
    
func _fishing_tick(_delta: float) -> void:
    pass

func _fishing_exit() -> void:
    fishing_end.emit()

func _on_free_walk() -> void:
    ground_base_speed = _ground_base_speed
    input.mouse_look_input = Vector2.ZERO

func _free_walk_tick(delta: float) -> void:
    super._physics_process(delta)
    
    if input.interact:
        sm.go_to(FISHING)
        
    if velocity.length() <= 0.0:
        if !footstep_timer.is_stopped():
            footstep_timer.stop()
    else:
        if footstep_timer.is_stopped():
            footstep_timer.start()

func _on_free_walk_exit() -> void:
    footstep_timer.stop()
    footstep_player.stop()
    
func _on_fish_caught() -> void:
    _fishing_game.queue_free()
    
    await get_tree().create_timer(0.5).timeout
    
    sm.go_to(FREE_WALK)
