extends Camera2D


var time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	offset.x = sin(time * 0.2) * 5
	offset.y = sin(time * 0.3) * 5
