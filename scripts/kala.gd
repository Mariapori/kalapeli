extends Node2D

@export var level = 1

func _physics_process(delta: float) -> void:
	$Label.text = str(level)
	$Sprite2D.flip_h = true
	scale = Vector2(0.5, 0.5) * (1 + (level - 1) * 0.1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player = body.get_parent()
		player.eatOrDead(self)
