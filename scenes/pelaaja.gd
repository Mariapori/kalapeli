extends Node2D

@export var speed = 5

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_D):
		self.translate(Vector2(speed,0))
	if Input.is_key_pressed(KEY_A):
		self.translate(Vector2(-speed,0))
	if Input.is_key_pressed(KEY_W):
		self.translate(Vector2(0,-speed))
	if Input.is_key_pressed(KEY_S):
		self.translate(Vector2(0,speed))
