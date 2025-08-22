@tool
class_name FishingLine
extends Node2D

signal fish_hooked(body: Node)

@export_tool_button("Generate") var pressed = _generate_line

@export var length = 30
@export var width = 4
@export var height = 8
@export var sprite : Texture2D

@export var root_path : NodePath

var overlap = 0.2

const FISHING_LINE = preload("res://resources/shaders/fishing_line.gdshader")
const HOOK = preload("res://scenes/fishing_minigame/hook.tscn")
const FILL = preload("res://resources/shaders/fill.gdshader")

var relative : Vector2

func _ready() -> void:
    if not Engine.is_editor_hint():
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        relative = event.screen_relative

func _physics_process(delta: float) -> void:
    if not Engine.is_editor_hint():
        var root : RigidBody2D = get_node_or_null(root_path)
        
        root.linear_velocity = relative * 5.0
        
        relative = Vector2.ZERO
    
func _generate_line() -> void:
    var mat := ShaderMaterial.new()
    mat.shader = FISHING_LINE
    mat.set_shader_parameter(&"width", float(width))
    mat.set_shader_parameter(&"height", float(height))
    
    var image := _make_image(Vector2(width, height))
    
    for child in get_children():
        child.free()
    
    var shape := CollisionShape2D.new()
    shape.shape = RectangleShape2D.new()
    shape.shape.size = Vector2(16.0, 16.0)
    shape.name = "CollisionShape2D"
    
    var n := RigidBody2D.new()
    n.gravity_scale = 0.0
    n.mass = 100.0
    n.name = "Root"
    
    add_child(n)
    n.add_child(shape)
    
    root_path = get_path_to(n)
    
    n.owner = get_tree().edited_scene_root
    shape.owner = get_tree().edited_scene_root
    
    var last_body = n
    
    for idx: int in range(length):
        var rd := _create_rigid_body(idx)
        _create_collision_shape(idx, rd)
        _create_sprite(image, mat, rd)
        _create_joint(idx, last_body, rd)
        
        last_body = rd
    
        var is_last_iteration : bool = idx == (length - 1)
        if is_last_iteration:
            var hook := HOOK.instantiate()
            hook.body_entered.connect(_body_entered)

func _create_rigid_body(idx: int) -> RigidBody2D:
    var rd := RigidBody2D.new()
    rd.position = Vector2(0, height * idx + (height / 2.0))
    rd.name = "RigidBody_%d" % idx
    rd.linear_damp = 1.0
    rd.set_collision_layer_value(1, false)
    rd.set_collision_mask_value(1, false)
    
    add_child(rd)
    rd.owner = get_tree().edited_scene_root
    
    return rd

func _create_sprite(img: ImageTexture, mat: ShaderMaterial, rd: RigidBody2D) -> Sprite2D:
    var s := Sprite2D.new()
    s.texture = img
    s.material = mat
    s.name = "Sprite2D"
    s.centered = false
    
    rd.add_child(s)
    s.position = -Vector2(float(width) / 2.0, float(height) / 2.0)
    
    s.owner = get_tree().edited_scene_root
    
    return s

func _create_collision_shape(idx: int, rd: RigidBody2D) -> CollisionShape2D:
    var rect :=  RectangleShape2D.new()
    rect.size = Vector2(width, height)
    
    var colshape := CollisionShape2D.new()
    colshape.shape = rect
    colshape.name = "CollisionShape2D"
    
    rd.add_child(colshape)
    colshape.owner = get_tree().edited_scene_root
    
    return colshape

func _create_joint(idx: int, last_body: Node, rd: RigidBody2D) -> PinJoint2D:
    var joint := PinJoint2D.new()
    joint.name = "PinJoint_%d" % idx
    
    add_child(joint)
    
    joint.node_a = joint.get_path_to(last_body)
    joint.node_b = joint.get_path_to(rd)
    
    joint.position = Vector2(0, height * idx)
    joint.owner = get_tree().edited_scene_root
    
    joint.angular_limit_enabled = true
    joint.angular_limit_lower = -90.0
    joint.angular_limit_upper = 90.0
    
    return joint

func _body_entered(body: Node) -> void:
    fish_hooked.emit(body)

func _make_image(size: Vector2) -> ImageTexture:
    var i := Image.create(
        size.x,
        size.y,
        false,
        Image.FORMAT_RGBA8
    )
    
    for y in range(size.y):
        for x in range(size.x):
            i.set_pixel(x, y, Color.WHITE)
    
    return ImageTexture.create_from_image(i)
