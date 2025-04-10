extends Node2D

@export var speed = 250
@export var level = 1
@export var zoom_factor: float = 0.5
@export var max_zoom_out: float = 10  
@export var min_zoom_in: float = 1 
@export var cam : Camera2D
@export var fishEat: AudioStream
@export var joystick : VirtualJoystick
func _physics_process(delta: float) -> void:	
	
	scale = Vector2(1, 1) * (1 + (level - 1) * 0.1)
	var target_zoom = clamp(1 / scale.length() * zoom_factor, min_zoom_in, max_zoom_out)
	cam.zoom = Vector2(target_zoom, target_zoom)
	cam.position = self.position
	$Label.text = str(level)
	var velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * speed * delta
	
	if not is_outside_border(self, $"../TextureRect", velocity):
		self.translate(velocity)
		
	if velocity.length() > 0:
		rotation = velocity.angle()
		if velocity.x < 0:
			$Sprite2D.scale.y = -1
			$Label.scale.y = -1
			$Label.scale.x = -1
		else:
			$Sprite2D.scale.y = 1
			$Label.scale.y = 1
			$Label.scale.x = 1
	

func eatOrDead(fish: Node2D) -> void:
	if fish.level <= level:
		level += fish.level
		$AudioStreamPlayer.stream = fishEat
		$AudioStreamPlayer.play()
		if level >= 300:
			get_tree().reload_current_scene()
		fish.queue_free()
	else:
		get_tree().reload_current_scene()
		
		
func is_outside_border(moving_node: Node2D, border_node: TextureRect, velocity: Vector2) -> bool:
	var new_position = moving_node.global_position + velocity
	var moving_size = $Sprite2D.get_rect().size
	var moving_rect = Rect2(new_position - moving_size / 2, moving_size)

	var border_global_position = border_node.global_position
	var border_size = border_node.size
	var border_rect = Rect2(border_global_position, border_size)

	return not border_rect.encloses(moving_rect)
