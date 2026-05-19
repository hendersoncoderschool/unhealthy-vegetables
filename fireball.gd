extends CharacterBody2D
@export var speed = 200
@onready var target_node = get_tree().get_first_node_in_group("player")
@onready var spawner = get_tree().get_first_node_in_group("spawner")
var waveNumber = 1
func _ready():
	pass

func _process(_delta):
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()
		if body.is_in_group("player"):
			body.take_damage(1, velocity)
			queue_free()
		if body.is_in_group("boss"):
			queue_free()
		if body.is_in_group("fireball"):
			queue_free()
		if body.is_in_group("wall"):
			queue_free()
		if spawner.waveNumber % 5 != 0:
			queue_free()
func _physics_process(_delta):
	move_and_slide()
	
func set_direction(dir: Vector2):
	velocity = dir.normalized() * speed
	

	
