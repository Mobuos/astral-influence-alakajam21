@tool
extends Node2D
class_name Planet


@onready var _collision: CollisionShape2D = $Area2D/CollisionShape2D
var mass := 20

@export_range(5, 100) var radius := 20.0
@export var color := Color(0xf5f5f5ff)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var shape = CircleShape2D.new()
	_collision.shape = shape
	shape.radius = radius
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
