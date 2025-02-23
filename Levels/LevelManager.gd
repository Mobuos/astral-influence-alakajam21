extends Node

# Levels
const INTRO = preload("res://Levels/Intro.tscn")
const ONE = preload("res://Levels/ONE.tscn")
const END = preload("res://Levels/End.tscn")
const BLACK_HOLE = preload("res://Levels/BlackHole.tscn")
const BLACK_HOLE_2 = preload("res://Levels/BlackHole2.tscn")
const TWO = preload("res://Levels/TWO.tscn")
const FOUR = preload("res://Levels/FOUR.tscn")
const WHITE_HOLE = preload("res://Levels/WhiteHole.tscn")
const WHITE_HOLE_2 = preload("res://Levels/WhiteHole2.tscn")

const levels: Array[PackedScene] = [INTRO, ONE, BLACK_HOLE, BLACK_HOLE_2, TWO, WHITE_HOLE, WHITE_HOLE_2, FOUR, END]
var curr_level_index := 0
var curr_level: Space 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(curr_level_index)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 25)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func next_level() -> void:
	if curr_level_index < len(levels) - 1:
		curr_level_index += 1
		load_level(curr_level_index)
	else:
		print("No other level to load")

func load_level(num: int) -> void:
	print("Loading %s" % num)
	var level: Space = levels[num].instantiate()
	level.finished.connect(next_level)
	if curr_level:
		curr_level.queue_free()
		await curr_level.tree_exited
	curr_level = level
	add_child(level)
