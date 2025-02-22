@tool
extends StaticBody2D
class_name Goal

#const goalType = goal.CUP

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var detection: Area2D = $Detection
@onready var counter: RichTextLabel = $Counter
@export var goalQtd := 5

var qtd_inside := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	draw_polygon(collision_polygon_2d.polygon, [jColor.LIGHTER])


func _physics_process(delta: float) -> void:
	queue_redraw()


func get_qtd_inside() -> int:
	return len(detection.get_overlapping_bodies())


func set_score(num: int) -> void:
	counter.text = "[center]%s/%s" %  [num, goalQtd]
