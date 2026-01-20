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
	$Player.hurt.connect(_on_player_hurt)
	$Player.pickup.connect(_on_player_pickup)
	$GameTimer.timeout.connect(_on_game_timer_timeout)
	
## Initializes everything we need to start the game.
func new_game() -> void:
	score = 0
	level = 1
	$HUD.update_score(score)
	$HUD.update_time(playtime)
	playing = true
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins()

func game_over() -> void:
	playing = false
	get_tree().call_group("coins", "queue_free")
	$GameTimer.stop()
	$Player.die()
	$HUD.show_game_over()
	
## Spawns instances of the coin scene according to level and curve.
func spawn_coins() -> void:
	for i in (level + curve):
		var c: Coin = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		# NOTE: Narrowing conversion here doesn't really matter.
		# Bakit may narrowing conversion dito lods? LMAO.
		@warning_ignore("narrowing_conversion")
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))

## Runs once per frame.
func _process(_delta: float) -> void:
	# Interrogate the tree if coins still exist.
	if (playing and (get_tree().get_nodes_in_group("coins").size() == 0)):
			level += 1
			time_left += 5
			spawn_coins()

func _on_game_timer_timeout() -> void:
	time_left -= 1
	$HUD.update_time(time_left)
	if time_left <= 0:
		game_over()

func _on_hud_start_game() -> void:
	new_game()

func _on_player_hurt() -> void:
	game_over()

func _on_player_pickup() -> void:
	score += 1
	$HUD.update_score(score)
