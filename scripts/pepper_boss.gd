extends CharacterBody2D
#*****************************************************************************************
#VARIABLES
var health = 40
var atkCooldown: int = 2
var specAtkCooldown: int = 5
@onready var player = get_tree().get_first_node_in_group("player")
var speed = 75
var specialattack_count = 4 
var fireballscene = load("res://scenes/fireball.tscn")
var specialfireballscene = load("res://scenes/special_fireball.tscn")
@onready var fireballtop = $Fireball_Top
@onready var fireballbottom = $Fireball_Bottom
@onready var camera :Camera2D = get_viewport().get_camera_2d()
signal noHealth
#*****************************************************************************************
#READY FUNCTION
func _ready():
	attack_loop()
	spec_attack_loop()
#*****************************************************************************************
#UPDATE FUNCTION
func _physics_process(delta):
	if health <= 0: 
		emit_signal("noHealth")
		queue_free()
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * speed
	print(self.health)
	move_and_slide()
	for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var body = collision.get_collider()
			if body.is_in_group("player"):
				body.take_damage(1, velocity)
				print(body.health)
#*****************************************************************************************
func attack_loop():
	while health > 0:
		await get_tree().create_timer(atkCooldown).timeout
		shoot_fireball()
func spec_attack_loop():
	while health > 0:
		await get_tree().create_timer(specAtkCooldown).timeout
		special_attack()
#*****************************************************************************************
func shoot_fireball():
	var dir = (player.global_position - global_position).normalized()
	var fireball = fireballscene.instantiate()
	get_tree().current_scene.add_child(fireball)
	if player != null:
			if player.global_position > global_position:
				fireball.global_position = fireballtop.global_position
			else:
				fireball.global_position = fireballbottom.global_position
			
	fireball.set_direction(dir)
	fireball.add_collision_exception_with(self)
#*****************************************************************************************
func special_attack():
	var viewport = get_viewport().get_visible_rect()
	var screenLeft = viewport.position.x
	var screenRight = viewport.position.x + viewport.size.x 
	var screenTop = viewport.position.y - 150
	var margin = viewport.size.y/float(specialattack_count)
	var shoot_y = screenTop
	for i in range(specialattack_count):
		var fireball = specialfireballscene.instantiate()
		get_tree().current_scene.add_child(fireball)
		var fireball_sprite = fireball.get_node("Fireball Sprite")
		if(i%2 == 0):
			var dir = Vector2.RIGHT
			fireball.global_position = Vector2(screenLeft,shoot_y)
			fireball.set_direction(dir)
		else:
			var dir = Vector2.LEFT
			fireball.global_position = Vector2(screenRight,shoot_y)
			fireball.set_direction(dir)
			fireball_sprite.flip_h = true
		shoot_y += margin
