@tool
extends StaticBody2D
class_name Planet

@onready var _collision: CollisionShape2D = $CollisionShape2D

@export_range(5, 100) var radius := 20.0
@export var mass := 5.0
@export var deleter := false

@export var movable: = false
var _hovered := false
var _is_dragging := false
var _offset := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var shape := CircleShape2D.new()
	_collision.shape = shape
	shape.radius = radius
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, jColor.LIGHTER)
	
	if movable && _hovered:
		_draw_hover()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()
	
	if _hovered && movable:
		if Input.is_action_pressed("mouse_click"):
			var mouse_pos := get_global_mouse_position()
			if !_is_dragging:
				_is_dragging = true
				_offset = mouse_pos - position
			position = mouse_pos - _offset
		elif Input.is_action_just_released("mouse_click"):
			_is_dragging = false


func _on_mouse_entered() -> void:
	scale = Vector2(1.05, 1.05)
	_hovered = true


func _on_mouse_exited() -> void:
	scale = Vector2.ONE
	_hovered = false


func _draw_hover() -> void:
	_draw_dashed_circle(radius + 5, 3.0, 2.0, jColor.LIGHT, 2)


func _draw_dashed_circle(radius: float, dash_length: float = 10.0, gap_length: float = 5.0, color: Color = Color.WHITE, width: float = -1.0) -> void:
	var points := PackedVector2Array()
	var total_length := 2 * PI * radius
	var segment_length := dash_length + gap_length
	var num_segments := int(total_length / segment_length)

	for i in range(num_segments):
		var angle_start := i * segment_length / total_length * TAU
		var angle_end := (i * segment_length + dash_length) / total_length * TAU
		
		var point_start := Vector2(cos(angle_start), sin(angle_start)) * radius
		var point_end := Vector2(cos(angle_end), sin(angle_end)) * radius
		
		points.append(point_start)
		points.append(point_end)

	draw_multiline(points, color, width)
