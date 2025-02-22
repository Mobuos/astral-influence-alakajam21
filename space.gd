extends Node2D

@export var line_color := Color.RED
var ballScene: PackedScene = preload("res://Balls/ball.tscn")

@onready var planets: Array[Node] = get_tree().get_nodes_in_group("Planet")
@onready var balls: Array[Node] = get_tree().get_nodes_in_group("Balls")
@onready var cannons: Array[Node] = get_tree().get_nodes_in_group("Cannon")
@onready var cannon = cannons[0] as Cannon


@export_category("Cannon")
@export_range(1, 50) var num_shots := 10
@onready var _shots = num_shots
@export var force := 20
@onready var cannon_timer: Timer = %CannonTimer
var shooting := false

const G = 0667439


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and !shooting:
		shooting = true
		cannon_timer.start()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		print("RESTARTING")
		shooting = false
		cannon_timer.stop()
		for ball: Ball in balls:
			ball.queue_free()
		balls = []


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


func createBall() -> Ball:
	var ball = ballScene.instantiate() as Ball
	add_child(ball)
	balls.append(ball)
	
	return ball


func launchBall(ball: Ball, cannon: Cannon) -> void:
	ball.position = cannon.position
	ball.apply_impulse(Vector2.from_angle(cannon.angle) * force)


func _on_cannon_timer_timeout() -> void:
	if _shots > 0:
		var ball := createBall()
		launchBall(ball, cannon)
		_shots -= 1
	else:
		shooting = false
		_shots = num_shots
		cannon_timer.stop()
