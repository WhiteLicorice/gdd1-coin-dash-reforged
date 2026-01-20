extends CanvasLayer

signal start_game

func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)
	$StartButton.pressed.connect(_on_start_button_pressed)

func update_score(value: int) -> void:
	print("update_score: %d" % value)
	$Figures/Score.text = str(value)
	
func update_time(value: int) -> void:
	print("update_time: %d" % value)
	$Figures/Time.text = str(value)

func show_message(text: String) -> void:
	$Message.text = text
	$Message.show()
	$Timer.start() # convenient!

func _on_timer_timeout():
	$Message.hide()
	
func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$Message.hide()
	start_game.emit()

func show_game_over() -> void:
	show_message("Game Over")
	await $Timer.timeout
	$StartButton.show()
	$Message.text = "Coin Dash!"
	$Message.show()
	
