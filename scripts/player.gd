class_name Player
extends SimpleFPSCharacter

signal fishing_start()

@export var footstep_timer : Timer
@export var footstep_player : AudioStreamPlayer
@export var canvas_layer : CanvasLayer

const GAME = preload("res://scenes/fishing_minigame/game.tscn")

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
    .on_enter(_on_fishing)
    
    var free_walk := State.new() \
    .on_enter(_on_free_walk) \
    .on_tick(_free_walk_tick)
    
    sm.add("fishing", fishing)
    sm.add("free_walk", free_walk)
    sm.initial_state("free_walk")

    footstep_timer.timeout.connect(_on_footstep_timeout)

func _on_footstep_timeout() -> void:
    footstep_player.stream = footstep_sounds.pick_random()
    footstep_player.play()

func _physics_process(delta: float) -> void:
    sm.tick(delta)
    
    if velocity.length() <= 0.0:
        if !footstep_timer.is_stopped():
            footstep_timer.stop()
    else:
        if footstep_timer.is_stopped():
            footstep_timer.start()
    
func _on_fishing() -> void:
    footstep_timer.stop()
    
    _ground_base_speed = ground_base_speed
    ground_base_speed = fishing_base_speed
    input.mouse_look_input = Vector2.ZERO
    
    rotation_behavior = RotationBehavior.look_at
    
    _fishing_game = GAME.instantiate()
    canvas_layer.add_child(_fishing_game)
    
    
func _fishing_tick(_delta: float) -> void:
    pass

func _fishing_exit() -> void:
    _fishing_game.free()

func _on_free_walk() -> void:
    ground_base_speed = _ground_base_speed

func _free_walk_tick(delta: float) -> void:
    super._physics_process(delta)
    
    if input.interact:
        sm.go_to("fishing")
