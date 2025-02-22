extends Node2D


var timer := Timer.new()


func _ready() -> void:
	timer.timeout.connect(fade)
	timer.wait_time = 5
	timer.one_shot = true
	add_child(timer)


# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_click") \
			or Input.is_action_just_pressed("restart") \
			or Input.is_action_just_pressed("ui_accept"):
		wait_and_fade()


func wait_and_fade() -> void:
	timer.start()


func fade() -> void:
	var tween = get_tree().create_tween()
	for child: Node in get_children():
		if child is CanvasItem:
			tween.tween_property(child, "modulate", Color.TRANSPARENT, 0.1)
			tween.tween_callback(child.queue_free)
