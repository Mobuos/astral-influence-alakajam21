@tool
extends StaticBody2D

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	draw_polygon(collision_polygon_2d.polygon, [jColor.LIGHTER])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
