extends Node2D

@export var coin_scene: PackedScene
@export var powerup_scene: PackedScene
@export var cactus_scene: PackedScene
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
	$PowerupTimer.timeout.connect(_on_powerup_timer_timeout)
	_randomize_powerup_timer()
	
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
	$PowerupTimer.start()
	spawn_coins()
	spawn_cactus()

func game_over() -> void:
	$EndSound.play()
	playing = false
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	get_tree().call_group("obstacles", "queue_free")
	$GameTimer.stop()
	$PowerupTimer.stop()
	$Player.die()
	$HUD.show_game_over()
	
## Spawns instances of the coin scene according to level and curve.
func spawn_coins() -> void:
	$LevelSound.play()
	for i in (level + curve):
		var c: Coin = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		# NOTE: Narrowing conversion here doesn't really matter.
		# Bakit may narrowing conversion dito lods? LMAO.
		@warning_ignore("narrowing_conversion")
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))

func spawn_cactus() -> void:
	for i in curve:
		var c = cactus_scene.instantiate()
		add_child(c)
		@warning_ignore("narrowing_conversion")
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		
## Runs once per frame.
func _process(_delta: float) -> void:
	# Interrogate the tree if coins still exist.
	if (playing and (get_tree().get_nodes_in_group("coins").size() == 0)):
			level += 1
			curve += 1
			time_left += 5
			spawn_coins()
			get_tree().call_group("obstacles", "queue_free")
			spawn_cactus()

func _on_game_timer_timeout() -> void:
	time_left -= 1
	$HUD.update_time(time_left)
	if time_left <= 0:
		game_over()

func _on_hud_start_game() -> void:
	new_game()

func _on_player_hurt() -> void:
	$EndSound.play()
	game_over()

func _on_player_pickup(strategy: String) -> void:
	match strategy:
		"coins":
			score += 1
			$HUD.update_score(score)
			$CoinSound.play()
		"powerups":
			time_left += 5
			$HUD.update_time(time_left)
			$PowerupSound.play()

func _on_powerup_timer_timeout() -> void:
	var p: Powerup = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	# NOTE: Narrowing conversion here doesn't really matter.
	# Bakit may narrowing conversion dito lods? LMAO.
	@warning_ignore("narrowing_conversion")
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
	_randomize_powerup_timer()

func _randomize_powerup_timer() -> void:
	var rand_time := randi_range(1, 10)
	print("_randomize_powerup_timer: %d" % rand_time)
	$PowerupTimer.set_deferred("wait_time", rand_time)
