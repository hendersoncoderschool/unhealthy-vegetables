extends CharacterBody2D
@export var speed = 200
@onready var target_node = get_tree().get_first_node_in_group("player")
func _ready():
	if target_node != null:
		var direction = global_position.direction_to(target_node.global_position)
		print(direction)
		velocity = direction*speed

func _process(_delta):
	move_and_slide()
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()
		if body.is_in_group("player"):
			body.take_damage(1, velocity)
			queue_free()
		if body.is_in_group("enemy"):
			queue_free()
		if body.is_in_group("wall"):
			queue_free()
