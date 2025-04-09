extends Node2D

@export var fish_scene: PackedScene
@export var spawn_interval: float = 2.0 
@export var player_node: NodePath 
@export var border_node: NodePath 

const MIN_DISTANCE: float = 100.0

var timer: Timer

func _ready():
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.connect("timeout", _on_Timer_timeout)
	add_child(timer)
	timer.start()

func _on_Timer_timeout():
	var player = get_node(player_node)
	var border = get_node(border_node) as TextureRect
	if player and border:
		
		var border_rect = Rect2(border.global_position, border.size)
		var spawn_position: Vector2
		var valid_spawn: bool = false
		var max_attempts: int = 10  
		var attempt: int = 0
		
		while not valid_spawn and attempt < max_attempts:
			attempt += 1
			
			var spawn_x = randf_range(border_rect.position.x, border_rect.position.x + border_rect.size.x)
			var spawn_y = randf_range(border_rect.position.y, border_rect.position.y + border_rect.size.y)
			spawn_position = Vector2(spawn_x, spawn_y)
			valid_spawn = true

			for fish in get_tree().get_nodes_in_group("fish"):
				if spawn_position.distance_to(fish.global_position) < MIN_DISTANCE:
					valid_spawn = false
					break
		
		if not valid_spawn:
			pass
		
		var fish = fish_scene.instantiate() as Node2D
		
		if randf() < 0.7:
			fish.level = player.level + 1 + (randi() % 10)
		else:
			fish.level = clamp(randi() % (player.level + 1), 1, player.level)
		fish.global_position = spawn_position
		get_parent().add_child(fish)
		fish.add_to_group("fish")
