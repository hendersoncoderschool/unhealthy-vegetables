extends Control

@onready var Heart_mask:Control = $HeartsMask
@onready var spawner = get_tree().get_first_node_in_group("spawner")


var maxHealth = 3
var health = 3
var healthWidth = 16

func _ready():
	setHealth(maxHealth)
	var player = get_tree().get_first_node_in_group("player")
	if player: 
		player.healthChanged.connect(setHealth)
	if spawner: 
		spawner.newWave.connect(setHealth)

func setMaxHealth(value):
	maxHealth = value 
	health = min(health,maxHealth)

	
func setHealth(value):
	health = clamp(value, 0, maxHealth)
	Heart_mask.custom_minimum_size.x = value * healthWidth
	Heart_mask.size.x = health * healthWidth
