@tool
extends StaticBody2D
class_name Planet

@onready var _collision: CollisionShape2D = $CollisionShape2D

@export_range(5, 200) var radius := 20.0
@export var mass := 5.0
@export var white_hole := false
@export var black_hole := false

@export var movable: = false
var _hovered := false
var _is_dragging := false
var _offset := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var shape := CircleShape2D.new()
	_collision.shape = shape
	shape.radius = radius
	
	if movable:
		z_index += 5
	
	queue_redraw()


func _draw() -> void:
	if black_hole:
		draw_circle(Vector2.ZERO + Vector2.RIGHT, radius, jColor.DARK)
		draw_circle(Vector2.ZERO, radius, jColor.DARKER)
	elif white_hole:
		draw_circle(Vector2.ZERO + Vector2.RIGHT, radius, jColor.LIGHTER)
		draw_circle(Vector2.ZERO, radius, jColor.LIGHT)
	else: # Planet
		draw_circle(Vector2.ZERO, radius, jColor.LIGHTER)
	
	if (movable and _hovered and !MouseState.holding) or _is_dragging :
		_draw_hover()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	if Engine.is_editor_hint():
		return
	
	var mouse_pos := get_global_mouse_position()
	
	if _is_dragging:
		rotation += delta
		scale = Vector2(1.05, 1.05)
	else:
		rotation += delta / 4
		scale = Vector2.ONE
	
	if MouseState.locked:
		_is_dragging = false
	
	if _hovered and movable and !MouseState.holding:
		if Input.is_action_pressed("mouse_click"):
			if !_is_dragging and !MouseState.locked:
				MouseState.holding = true
				_is_dragging = true
				_offset = mouse_pos - position
				
	if Input.is_action_just_released("mouse_click"):
		MouseState.holding = false
		set_collision_layer_value(2, true)
		_is_dragging = false
	
	if _is_dragging:
		set_collision_layer_value(2, false)
		self.move_and_collide((mouse_pos - _offset - position) * delta * 5)
		#position = mouse_pos - _offset


func _on_mouse_entered() -> void:
	_hovered = true


func _on_mouse_exited() -> void:
	_hovered = false


func _draw_hover() -> void:
	if MouseState.locked:
		_draw_dashed_circle(radius + 5, 5, 0, Color.ORANGE_RED, 2)
	else:
		_draw_dashed_circle(radius + 5, 3.0, 5.0, jColor.LIGHT)


@warning_ignore("shadowed_variable")
func _draw_dashed_circle(radius: float, dash_length: float = 10.0, gap_length: float = 5.0, color: Color = Color.WHITE, width: float = -1.0) -> void:
	var points := PackedVector2Array()
	var total_length := 2 * PI * radius
	var segment_length := dash_length + gap_length
	var num_segments := int(total_length / segment_length) + 1

	for i in range(num_segments):
		var angle_start := i * segment_length / total_length * TAU
		var angle_end := (i * segment_length + dash_length) / total_length * TAU
		
		var point_start := Vector2(cos(angle_start), sin(angle_start)) * radius
		var point_end := Vector2(cos(angle_end), sin(angle_end)) * radius
		
		points.append(point_start)
		points.append(point_end)

	draw_multiline(points, color, width)
