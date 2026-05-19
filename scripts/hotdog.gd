extends CharacterBody2D
@export var rotationSpeed = 7.5
@export var radius = 70
@export var speed = 250
@export var target: Node2D
@export var target_node_path:NodePath
@export var center:Node2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var upgrades = get_node("/root/Node2D/Upgrades UI")
var has_been_fired = false
var angle = 0
var target_angle = 0
var boss_fire_cooldown
var cooldown_timer = 1.5


func _physics_process(delta): #update function
	var mouse_position = get_global_mouse_position()
	var directionToMouse = (mouse_position - center.global_position).normalized()
	target_angle = directionToMouse.angle()
	angle = lerp_angle(angle, target_angle, rotationSpeed*delta)
	var newPosition = center.global_position + Vector2(cos(angle),sin(angle))*radius	
	
	if target.health <= 0:
		queue_free()
	
	if not has_been_fired:
		global_position = newPosition
	else:
		rotation += 0.25
		move_and_slide()
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var body = collision.get_collider()
			rotation += 300
			if body == null:
				continue
			elif body.is_in_group("enemy") and has_been_fired == true:
				body.health -= 1
				has_been_fired = false
				global_position = target.global_position + Vector2(cos(angle),sin(angle))*radius	
			elif body.is_in_group("kernel"):
				body.queue_free()
				has_been_fired = false
				global_position = target.global_position + Vector2(cos(angle),sin(angle))*radius	
			elif body.is_in_group("boss"):
				body.health -= 1
				has_been_fired = false
				boss_fire_cooldown = true
				global_position = target.global_position + Vector2(cos(angle),sin(angle))*radius	
				
				boss_cooldown()
				
			elif body.is_in_group("wall"):
				has_been_fired = false
				global_position = target.global_position + Vector2(cos(angle),sin(angle))*radius	
			elif body.is_in_group("fireball"):
				has_been_fired = false 
				global_position = target.global_position + Vector2(cos(angle), sin(angle))*radius
	
func _ready(): #start function
	boss_fire_cooldown = false
	if target_node_path:
		target = get_node(target_node_path)
	else:
		print("Warning: no target node set for hotdog")
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and has_been_fired == false and boss_fire_cooldown == false:
			has_been_fired = true
			var mouse_position = get_global_mouse_position()
			var direction = position.direction_to(mouse_position);
			velocity = direction*speed

func _on_visible_on_screen_notifier_2d_screen_exited(): #if the hot dog exits the screena
	has_been_fired = false
	global_position = target.global_position
	


#func _on_area_2d_body_entered(body: Node2D): #if hotdog hits enemy
	#print(body.name)

func boss_cooldown():
		await get_tree().create_timer(cooldown_timer).timeout
		boss_fire_cooldown = false


func size_button_down() -> void:
	scale *= 1.2
	player.exp_amount -= 5
	upgrades.visible = false
	get_tree().paused = false	

func _on_cooldown_upgrade_button_button_down() -> void:
	cooldown_timer *= 0.8
	print("cooldown upgrade")
	player.exp_amount -= 5
	upgrades.visible = false
	get_tree().paused = false
