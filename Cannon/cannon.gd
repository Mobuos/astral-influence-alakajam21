@tool
extends Node2D
class_name Cannon


@export_range(1, 20) var radius := 3.0
@export_range(0, 360, 0.1, "radians_as_degrees") var angle := 30.0
@export_range(1, 30) var cannon_size := 10
@export_range(1, 20) var cannon_width := 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()
	pass # Replace with function body.


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, jColor.DARK)
	draw_line(Vector2.ZERO, Vector2.from_angle(angle) * cannon_size, jColor.DARK, cannon_width)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	pass
