extends CharacterBody2D
@onready var target_node_path = get_tree().get_first_node_in_group("player")
var carrot_exp = load("res://scenes/exp_carrot.tscn")
var broc_exp = load("res://scenes/exp_broc.tscn")
@export var speed = 100
@export var health = 1
@export var veggie_type = "carrot"

var target: Node2D
func _ready(): #start function
	if target_node_path:
		target = target_node_path
	else:
		print("Warning: no target node set for vegetable")
func _physics_process(_delta): #update function
	if target != null:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction*speed
		move_and_slide()
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var body = collision.get_collider()
			if body.is_in_group("player"):
				body.take_damage(1, velocity)
				print(body.health)
		if health <= 0 && veggie_type == "carrot":
			var c_xp_collectable = carrot_exp.instantiate()
			get_tree().current_scene.add_child(c_xp_collectable)
			c_xp_collectable.global_position = global_position + Vector2(randf_range(-2,2), randf_range(-2,2))
			queue_free()	
		if health <= 0 && veggie_type == "brocolli":
			var b_xp_collectable = broc_exp.instantiate()
			get_tree().current_scene.add_child(b_xp_collectable)
			b_xp_collectable.global_position = global_position + Vector2(randf_range(-2,2), randf_range(-2,2))
			queue_free()
		
	if health <= 0:
		queue_free()
		
	
	
