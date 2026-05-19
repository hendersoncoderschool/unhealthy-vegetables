extends Area2D

@onready var player = get_tree().get_first_node_in_group("player")

func corn_exp_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.exp_amount += 1
		print("exp gained, you have " + str(body.exp_amount) + " exp points.")
		queue_free()
		
func _process(delta):
	#print(global_position.distance_to(player.global_position))
	if global_position.distance_to(player.global_position) < 150:
		global_position = global_position.move_toward(player.global_position, 100 * delta)
