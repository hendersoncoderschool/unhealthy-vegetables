extends Sprite2D
@onready var hotdog = get_tree().get_first_node_in_group("hotdog")
func _ready():
	scale.x = 0.25
	pass
	
func _process(delta):
	self.global_position.x = hotdog.global_position.x 
	self.global_position.y = hotdog.global_position.y + 30 
	if scale.x > 0.0:
		scale.x -= delta*0.15
	else:
		scale.x = 0.0
	if hotdog.has_been_fired == true:
		scale.x = 0.25
