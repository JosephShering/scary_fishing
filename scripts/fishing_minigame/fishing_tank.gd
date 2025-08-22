@tool
extends Node2D

@export_tool_button("Generate Tank") var generate_tank = _generate_tank

@export var width := 800.0
@export var height := 600.0

@export var static_size := 16.0

const FILL = preload("res://resources/shaders/fill.gdshader")

func _generate_tank() -> void:
    for child in get_children():
        child.free()
    
    _create_left_wall()
    _create_right_wall()
    _create_bottom_floor()

func _create_left_wall() -> void:
    _add_body(
        Vector2(
            0.0,
            height / 2.0
        ),
        Vector2(
            static_size,
            height
        )
    )
    
    
func _create_right_wall() -> void:
    _add_body(
        Vector2(
            width,
            height / 2.0
        ),
        Vector2(
            static_size,
            height
        )
    )
    
func _create_bottom_floor() -> void:
    _add_body(
        Vector2(
            width / 2.0,
            height
        ),
        Vector2(
            width,
            static_size
        )
    )

func _add_body(pos: Vector2, size: Vector2) -> void:
    var rect := RectangleShape2D.new()
    rect.size = size
    
    var col := CollisionShape2D.new()
    col.shape = rect
    
    var sb := StaticBody2D.new()
    sb.position = pos
    
    add_child(sb)
    sb.add_child(col)
    
    sb.owner = get_tree().edited_scene_root
    col.owner = get_tree().edited_scene_root
    
    _add_sprite(size, col)


func _add_sprite(size: Vector2, shape: CollisionShape2D) -> Sprite2D:
    var i := Image.create(
        size.x,
        size.y,
        false,
        Image.FORMAT_RGBA8
    )
    
    for y in range(size.y):
        for x in range(size.x):
            i.set_pixel(x, y, Color.WHITE)
    
    var it := ImageTexture.create_from_image(i)
    
    var s := ShaderMaterial.new()
    s.shader = FILL
    s.set_shader_parameter(&"color", Color.WHITE)
    
    var sprite := Sprite2D.new()
    sprite.texture = it
    sprite.material = s
    
    shape.add_child(sprite)
    sprite.owner = get_tree().edited_scene_root
    
    return sprite
