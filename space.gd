extends Node2D

@export var line_color := Color.RED
var ballScene: PackedScene = preload("res://Balls/ball.tscn")

@onready var planets: Array[Node] = get_tree().get_nodes_in_group("Planet")
@onready var balls: Array[Node] = get_tree().get_nodes_in_group("Balls")

const G = 0667439


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var ball = ballScene.instantiate() as Ball
		ball.position = get_local_mouse_position()
		add_child(ball)
		balls.append(ball)


func _physics_process(delta: float) -> void:
	for planet: Planet in planets:
		for ball: Ball in balls:
			var force = (planet.global_transform.origin
					- ball.global_transform.origin).normalized()\
					* G * ball.mass * planet.mass\
					/ (planet.global_transform.origin.\
					distance_squared_to(ball.global_transform.origin))
			ball.apply_force(force * delta)
	queue_redraw()
