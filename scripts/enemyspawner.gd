extends Node
#VARIABLES
#**************************************************************************************
@onready var player = get_tree().get_first_node_in_group("player")
signal newWave(maxHealth)
var waveNumber = 1
var cornEnemy = load("res://scenes/corn.tscn")
var carrotEnemy = load("res://scenes/carrot.tscn")
var brocEnemy = load("res://scenes/brocolli_body.tscn")
var pepper_boss = load("res://scenes/pepper_boss.tscn")
var cooldown_meter = load("res://scenes/cooldown_bar.tscn")
var random = RandomNumberGenerator.new()
var cam2D:Camera2D
var screenSize
var boss
var cd_bar
#**************************************************************************************
func _ready():
	boss = null
	if player != null:
		print("player found")
	cam2D = get_viewport().get_camera_2d()
	print(screenSize)
	screenSize = get_viewport().size
	for i in range (int(pow(waveNumber,1.25))+4):
			var enemy
			var spawnSide = random.randi_range(1,4)
			var enemyType = random.randi_range(1,4)
			if enemyType == 1:
				enemy = brocEnemy.instantiate()
			elif enemyType == 2:
				enemy = cornEnemy.instantiate()
			else:
				enemy = carrotEnemy.instantiate()
			add_child(enemy)
			#SPAWNING ENEMIES OFFSCREEN
			if spawnSide == 1:
				enemy.global_position.y = screenSize.y/2
				var randomX = random.randi_range(screenSize.x/2 * -1, screenSize.x/2)
				enemy.global_position.x = randomX
				if enemyType == 2:
					enemy.global_position.y -= 50
			elif spawnSide == 2:
				enemy.global_position.y = screenSize.y/-2
				var randomX = random.randi_range(screenSize.x/2 * -1, screenSize.x/2)
				enemy.global_position.x = randomX
				if enemyType == 2:
					enemy.global_position.y += 50
			elif spawnSide == 3:
				enemy.global_position.x = screenSize.x/2
				var randomY = random.randi_range(screenSize.y/2 * -1, screenSize.y/2)
				enemy.global_position.y = randomY
				if enemyType == 2:
					enemy.global_position.x -= 50
			elif spawnSide == 4:
				enemy.global_position.x = screenSize.x/-2
				var randomY = random.randi_range(screenSize.y/2 * -1, screenSize.y/2)
				enemy.global_position.y = randomY
				if enemyType == 2:
					enemy.global_position.x += 50
					
func _process(float):
	var enemiesAlive = get_tree().get_nodes_in_group("enemy")
	if enemiesAlive.size() == 0 and boss == null:
		waveNumber = waveNumber + 1
		player.health = 3
		emit_signal("newWave", 3)
		if waveNumber % 5 == 0:
				boss = pepper_boss.instantiate()
				cd_bar = cooldown_meter.instantiate()
				add_child(boss)
				add_child(cd_bar)
				await boss.noHealth
				boss.queue_free()
				cd_bar.queue_free()
		else:
			for i in range (int(pow(waveNumber,1.25)+3)):
					var spawnSide = random.randi_range(1,4)
					var enemyType = random.randi_range(1,4)
					var enemy
					if enemyType == 1:
						enemy = brocEnemy.instantiate()
					elif enemyType == 2:
						enemy = cornEnemy.instantiate()
					else:
						enemy = carrotEnemy.instantiate()
					add_child(enemy)
					#SPAWNING ENEMIES OFFSCREEN
					if spawnSide == 1:
						enemy.global_position.y = screenSize.y/2
						var randomX = random.randi_range(screenSize.x/2 * -1, screenSize.x/2)
						enemy.global_position.x = randomX
						if enemyType == 2:
							enemy.global_position.y -= 50
					elif spawnSide == 2:
						enemy.global_position.y = screenSize.y/-2
						var randomX = random.randi_range(screenSize.x/2 * -1, screenSize.x/2)
						enemy.global_position.x = randomX
						if enemyType == 2:
							enemy.global_position.y += 50
					elif spawnSide == 3:
						enemy.global_position.x = screenSize.x/2
						var randomY = random.randi_range(screenSize.y/2 * -1, screenSize.y/2)
						enemy.global_position.y = randomY
						if enemyType == 2:
							enemy.global_position.x -= 50
					elif spawnSide == 4:
						enemy.global_position.x = screenSize.x/-2
						var randomY = random.randi_range(screenSize.y/2 * -1, screenSize.y/2)
						enemy.global_position.y = randomY
						if enemyType == 2:
							enemy.global_position.x += 50
