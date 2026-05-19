extends CharacterBody2D

var kernelscene = load("res://scenes/kernel.tscn")
var corn_xp = load("res://scenes/exp_corn.tscn")
@export var health = 1 
@export var attackspeed = 3
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	if health > 0 and  get_tree().paused == false:
		await get_tree().create_timer(attackspeed).timeout
		var kernel = kernelscene.instantiate()
		add_child(kernel)
		if player != null:
			if abs(player.global_position.y - global_position.y) > 10:
				if player.global_position.y < global_position.y:
					print("move up now pls")
					kernel.global_position.y -= 30
				else:
					kernel.global_position.y += 30
			if abs(player.global_position.x - global_position.x) > 10:
				if player.global_position.x < global_position.x:
					kernel.global_position.x -= 30 
				else:
					kernel.global_position.x += 30 
		

func _physics_process(_delta):	
	if health <= 0:
		var xp_collectable = corn_xp.instantiate()
		get_tree().current_scene.add_child(xp_collectable)
		xp_collectable.global_position = global_position + Vector2(randf_range(-2,2), randf_range(-2,2))
		queue_free()	
