extends Node2D
class_name Space

@export var line_color := Color.RED
@export var goal: Goal
@export var goal_offset: int = 1
@export var freeSpace := false
@onready var vump: AudioStreamPlayer2D = $vump
@onready var cannonplayer: AudioStreamPlayer2D = $cannonplayer
@onready var restart: AudioStreamPlayer2D = $restart

var ballScene: PackedScene = preload("res://Balls/ball.tscn")
var goalMet := false
signal finished

@onready var planets: Array[Node] = get_tree().get_nodes_in_group("Planet")
@onready var balls: Array[Node] = get_tree().get_nodes_in_group("Balls")
@onready var cannons: Array[Node] = get_tree().get_nodes_in_group("Cannon")
@onready var background: Sprite2D = $Background
@onready var next_level_ui: Node2D = $"Next Level UI"

@export_category("Cannon")
@export_range(1, 50) var num_shots := 10
@onready var _shots := num_shots
@export var cannon_force := 20
@onready var cannon_timer: Timer = %CannonTimer
@onready var cannon_preview_timer: Timer = %CannonPreviewTimer
var shooting := false
var _locked := false

const G = 0667439


func _ready() -> void:
	Engine.time_scale = 1.5
	next_level_ui.modulate.a = 0
	MouseState.locked = false
	MouseState.holding = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		restart.pitch_scale = 0.8
		restart.play()
		MouseState.locked = false
		restart_balls()
	
	if Input.is_action_just_pressed("fire"):
		restart.pitch_scale = 2
		restart.play()
		if !freeSpace:
			restart_balls()
			MouseState.locked = true
		shooting = true
		cannon_timer.start()
	
	# Check for win condition
	if goal.get_qtd_inside() - goal_offset >= goal.goalQtd or goalMet:
		goalMet = true
		if next_level_ui.modulate.a == 0:
			var tween := get_tree().create_tween()
			tween.tween_property(next_level_ui, "modulate", Color.WHITE, 0.5)
		if Input.is_action_just_pressed("next"):
			finished.emit()
	
	background.rotate(delta / 1000)


func _physics_process(delta: float) -> void:
	for planet: Planet in planets:
		# Don't calculate gravity for held planets
		if planet._is_dragging:
			continue
		for ball: Ball in balls:
			var force := (planet.global_transform.origin
					- ball.global_transform.origin).normalized()\
					* G * ball.mass * planet.mass\
					/ (planet.global_transform.origin.\
					distance_squared_to(ball.global_transform.origin))
			ball.apply_force(force * delta)
	
	goal.set_score(goal.get_qtd_inside() - goal_offset)
	queue_redraw()


func restart_balls() -> void:
	shooting = false
	cannon_timer.stop()
	_shots = num_shots
	for ball: Ball in balls:
		ball.queue_free()
	balls = []


func createBall(temporary: bool = false) -> Ball:
	var ball := ballScene.instantiate() as Ball
	ball.temporary = temporary
	ball.hit.connect(_on_ball_hit)
	add_child(ball)
	balls.append(ball)
	
	return ball


func launchBall(ball: Ball, c: Cannon) -> void:
	ball.position = c.position + Vector2.from_angle(c.angle) * c.cannon_size
	ball.apply_impulse(Vector2.from_angle(c.angle) * cannon_force)


func deleteBall(ball: Ball) -> void:
	balls.erase(ball)
	ball.queue_free()
	if balls.is_empty():
		MouseState.locked = false
		restart_balls()


func _on_cannon_timer_timeout() -> void:
	if _shots > 0:
		for cannon: Cannon in cannons:
			var ball := createBall()
			launchBall(ball, cannon)
			cannonplayer.play()
		_shots -= 1
	else:
		shooting = false
		_shots = num_shots
		cannon_timer.stop()


func _on_cannon_preview_timer_timeout() -> void:
	for cannon: Cannon in cannons:
		var ball := createBall(true)
		ball.color = jColor.DARK
		ball.radius = 1
		launchBall(ball, cannon)


func _on_ball_hit(ref: Node) -> void:
	vump.play()
	deleteBall(ref)


#func _draw() -> void:
	#_draw_aim()

# This is wonky
#func _draw_aim() -> void:
	## Adjust the angle if your cannon sprite is drawn facing up.
	## Godot's 0 radians points right, so subtract PI/2 to have 0 mean "up."
	#var adjusted_angle := cannon.rotation - PI/2
	#var vel := Vector2.from_angle(adjusted_angle) * cannon_force
	#
	#var tstep := 0.05
	#var start_pos: Vector2 = cannon.global_position
	#draw_circle(start_pos, 5, Color.RED)
	#
	#var line_start := start_pos
	#var line_end := start_pos
	#var colors := [jColor.LIGHT, Color.TRANSPARENT]
#
	## Temporary simulation variables
	#var sim_vel := vel
	#var sim_pos := start_pos
	#
	#for i in range(1, 151):
		#var force_accum := Vector2.ZERO
#
		## Simulate gravitational forces from all planets
		#for planet: Planet in planets:
			#var direction := planet.global_transform.origin - sim_pos
			#var distance_sq := direction.length_squared()
			#if distance_sq == 0:
				#continue  # Avoid division by zero
			#var gravity_force := direction.normalized() * (G * planet.mass / distance_sq)
			#force_accum += gravity_force
#
		## Update velocity and position using Euler integration
		#sim_vel += force_accum * tstep
		#line_end = sim_pos + sim_vel * tstep
#
		## Draw the segment of the predicted trajectory
		#draw_line(line_start, line_end, colors[i % 2])
#
		## Update for next iteration
		#line_start = line_end
		#sim_pos = line_end
