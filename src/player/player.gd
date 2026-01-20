extends Area2D

signal pickup(strategy: String)
signal hurt

## Speed of the player.
@export_range(0, 999) var speed := 350.0
## The current velocity of the player.
var velocity := Vector2.ZERO
## Controls player's movement bounds.
var screensize := Vector2.ZERO

## Called once upon instantiation.
func _ready() -> void:
	connect("area_entered", _on_area_entered)

## Called outside to initialize the player once upon instantiation.
func start() -> void:
	position = screensize / 2
	$AnimatedSprite2D.animation = "idle"
	set_process(true)
	
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

func die() -> void:
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)

func _on_area_entered(area: Area2D) -> void:
	var pickup_strategy = _resolve_pickup_strategy(area)
	if pickup_strategy:
		area.pickup()
		pickup.emit(pickup_strategy)
	
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()

func _resolve_pickup_strategy(area: Area2D) -> String:
	if not area.has_method("pickup"):
		push_warning("(player) `_resolve_pickup_strategy`: %s does not define method `pickup`." % area)
		return ""
	if area.is_in_group("coins"): return "coins"
	if area.is_in_group("powerups"): return "powerups"
	push_warning("(player) `_resolve_pickup_strategy`: %s does not belong to a valid group." % area)
	return ""

	
