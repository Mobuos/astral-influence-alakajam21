extends Node

# Levels
const INTRO = preload("res://Levels/Intro.tscn")
const ONE = preload("res://Levels/ONE.tscn")
const END = preload("res://Levels/End.tscn")
const BLACK_HOLE = preload("res://Levels/BlackHole.tscn")
const BLACK_HOLE_2 = preload("res://Levels/BlackHole2.tscn")

const levels: Array[PackedScene] = [BLACK_HOLE_2, INTRO, ONE, BLACK_HOLE, END]
var curr_level_index = 0
var curr_level: Space 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(curr_level_index)


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
