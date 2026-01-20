class_name Coin extends Area2D

var screensize = Vector2.ZERO

func pickup() -> void:
	queue_free()
