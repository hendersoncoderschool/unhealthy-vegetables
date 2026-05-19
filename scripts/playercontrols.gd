extends CharacterBody2D

var exp_amount = 0
@export var speed = 140
@export var health = 3
@export var has_Iframes = false
@export var knockback = Vector2.ZERO

@onready var fireballTop = get_tree().get_first_node_in_group("shooting")
@onready var fireballBottom = get_tree().get_first_node_in_group("shooting")

@onready var upgrades = get_node("/root/Node2D/Upgrades UI")
@onready var gameover = get_node("/root/Node2D/Game_Over")

signal healthChanged(newHealth)


func get_input(): #input from player
	var inputdirection = Input.get_vector("left","right","up","down")
	velocity = inputdirection * speed + knockback
	
func _physics_process(_delta): #update function
	get_input()
	move_and_slide()
	knockback = knockback.lerp(Vector2.ZERO,0.1)
	if health <= 0:
		print("player is dead");
		gameover.visible = true 
		queue_free()
	#add_collision_exception_with(fireballTop)
	#add_collision_exception_with(fireballBottom)
	if exp_amount % 15 == 0 and get_tree().paused == false and exp_amount > 0:
		get_tree().paused = true
		upgrades.visible = true
func take_damage(damage, enemyVelocity):
	if has_Iframes == false:
		health -= damage
		knockback = enemyVelocity.normalized() * 1000
		emit_signal("healthChanged", health)
		has_Iframes = true 
		await get_tree().create_timer(0.5).timeout
		has_Iframes = false
		
func reset_health():
	health = 3
	emit_signal("healthChanged", health)
		
func on_speed_boost_down() -> void:
	speed *= 1.15
	exp_amount -= 5
	upgrades.visible = false
	get_tree().paused = false


func restart_button_press() -> void:
	get_tree().reload_current_scene()
