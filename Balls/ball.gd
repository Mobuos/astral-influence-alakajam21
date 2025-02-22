@tool
extends RigidBody2D
class_name Ball

@onready var _collision: CollisionShape2D = $CollisionShape2D

@export_range(1, 20) var radius := 3.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var shape := CircleShape2D.new()
	_collision.shape = shape
	shape.radius = radius
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, jColor.LIGHT)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()
