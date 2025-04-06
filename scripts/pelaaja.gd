extends Node2D

@export var speed = 5
@export var level = 1

func _physics_process(delta: float) -> void:	
	$Label.text = str(level)
	if Input.is_key_pressed(KEY_D):
		self.translate(Vector2(speed,0))
	if Input.is_key_pressed(KEY_A):
		self.translate(Vector2(-speed,0))
	if Input.is_key_pressed(KEY_W):
		self.translate(Vector2(0,-speed))
	if Input.is_key_pressed(KEY_S):
		self.translate(Vector2(0,speed))

func eatOrDead(fish: Node2D) -> void:
	if fish.level <= level:
		level += fish.level
		fish.queue_free()
	else:
		# TODO: Make gameover logic
		print("Et voi syödä isompaa kalaa")
		pass
