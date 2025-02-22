@tool
extends Node2D

@export var line_color := Color.RED


@onready var planets: Array[Node] = get_tree().get_nodes_in_group("Planet")


var balls: Array[Vector2] = []
var timer := 0.0


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and timer <= 0:
		balls.append(Vector2(event.position))


func _physics_process(delta: float) -> void:
	#for planet: Planet in planets:
		#for ball in balls:
			
	queue_redraw()


func _process(delta: float) -> void:
	if timer < 0:
		timer = 0
	else:
		timer -= delta


func _draw() -> void:
	for ball in balls:
		draw_circle(ball, 2, Color.WHITE)
