extends Area2D

## Speed of the player.
@export_range(0, 999) var speed := 350.0
## The current velocity of the player.
var velocity := Vector2.ZERO
## Controls player's movement bounds.
var screensize := Vector2(480, 720)

## Runs once upon instantiation.
func _ready() -> void:
	position = screensize / 2
	$AnimatedSprite2D.animation = "idle"
	
## Runs per frame.
func _process(delta: float) -> void:
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * speed * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	if (velocity.length() > 0):
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	if (velocity.x != 0):
		$AnimatedSprite2D.flip_h = velocity.x < 0

func hurt() -> void:
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)

	
	
