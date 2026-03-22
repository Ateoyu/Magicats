extends Area2D

var damage: Int = 0

func _on_body_entered(body: Node2D) -> void:
		if body is Player:
			body.take_damage(10)
			print("You got hit!")
