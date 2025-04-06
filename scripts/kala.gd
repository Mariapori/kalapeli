extends Node2D

@export var level = 1

func _physics_process(delta: float) -> void:
	$Label.text = str(level)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player = body.get_parent()
		player.eatOrDead(self)
