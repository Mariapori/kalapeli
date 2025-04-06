extends Node2D

@export var fish_scene: PackedScene  # Vedä Fish.tscn editorissa tähän
@export var spawn_interval: float = 2.0  # Sekunteina
@export var player_node: NodePath  # Vedä pelaajan Node2D tähän
@export var border_node: NodePath  # Vedä TextureRect editorissa tähän

# Määritellään minimietäisyys kahden kalan välillä
const MIN_DISTANCE: float = 50.0

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
		# Lasketaan borderin Rect2
		var border_rect = Rect2(border.global_position, border.size)
		var spawn_position: Vector2
		var valid_spawn: bool = false
		var max_attempts: int = 10  # Yritetään enintään 10 kertaa löytää sopiva paikka
		var attempt: int = 0
		
		while not valid_spawn and attempt < max_attempts:
			attempt += 1
			# Generoidaan satunnainen paikka borderin sisällä
			var spawn_x = randf_range(border_rect.position.x, border_rect.position.x + border_rect.size.x)
			var spawn_y = randf_range(border_rect.position.y, border_rect.position.y + border_rect.size.y)
			spawn_position = Vector2(spawn_x, spawn_y)
			valid_spawn = true

			# Käydään läpi kaikki jo spawnatut kalat (oletamme, että ne on lisätty "fish"-ryhmään)
			for fish in get_tree().get_nodes_in_group("fish"):
				if spawn_position.distance_to(fish.global_position) < MIN_DISTANCE:
					valid_spawn = false
					break
		
		# Jos sopivaa paikkaa ei löydetty, voidaan hypätä pois tai käyttää viimeistä spawnattua paikkaa
		if not valid_spawn:
			# Voidaan esimerkiksi käyttää viimeksi generoitua paikkaa,
			# tai palata funktiosta returnilla.
			# Tässä käytämme viimeistä spawn_positionia.
			pass
		
		# Luodaan uusi kala
		var fish = fish_scene.instantiate() as Node2D
		fish.level = clamp(randi() % (player.level + 1), 1, player.level + 1)
		fish.global_position = spawn_position
		get_parent().add_child(fish)
		# Lisätään kala ryhmään "fish", jotta sitä voidaan myöhemmin hakea helposti
		fish.add_to_group("fish")
