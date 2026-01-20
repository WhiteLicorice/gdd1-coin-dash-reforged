extends Node2D

@export var coin_scene: PackedScene
@export var playtime: int
@export var curve := 5

var score := 1
var level := 1
var time_left := 0
var screensize := Vector2.ZERO
var playing := false

## Runs once upon instantiation.
func _ready() -> void:
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	new_game() # TODO: Move this to UI control later.
	
## Initializes everything we need to start the game.
func new_game() -> void:
	score = 0
	level = 1
	playing = true
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins()

## Spawns instances of the coin scene according to level and curve.
func spawn_coins() -> void:
	for i in (level + curve):
		var c: Coin = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		# NOTE: Narrowing conversion here doesn't really matter.
		# Bakit may narrowing conversion dito lods? LMAO.
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))

## Runs once per frame.
func _process(_delta: float) -> void:
	# Interrogate the tree if coins still exist.
	if (playing and (get_tree().get_nodes_in_group("coins").size() == 0)):
			level += 1
			time_left += 5
			spawn_coins()
