class_name Powerup extends Area2D

var screensize = Vector2.ZERO

func _ready():
	$Timer.timeout.connect(on_powerup_timer_timeout)
	$AnimationTimer.start(randf_range(3, 8))
	$AnimationTimer.timeout.connect(_on_animation_timer_timeout)
	area_entered.connect(_on_area_entered)

func _on_animation_timer_timeout() -> void:
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()

func pickup() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", scale * 3, 0.3)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	await tween.finished
	queue_free()

func on_powerup_timer_timeout() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacles"):
		Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
