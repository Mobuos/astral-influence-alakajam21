@tool
extends RigidBody2D
class_name Ball

@onready var _collision: CollisionShape2D = $CollisionShape2D

@export_range(1, 20) var radius := 3.0

@onready var color := jColor.LIGHT
var temporary := false

signal hit(ref: Node)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if temporary:
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
	var shape := CircleShape2D.new()
	_collision.shape = shape
	shape.radius = radius
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	hit.emit(self)
