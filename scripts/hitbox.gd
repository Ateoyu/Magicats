extends Area2D

var damage: int = 0

func _on_body_entered(body: Node2D) -> void:
		if body is Player:
			body.take_damage(10)
