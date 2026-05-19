extends Sprite2D

@export var heartX = 0
@export var healthTexture: AtlasTexture 

func updateHearts(direction):
	heartX -= direction*19
	#region_rect = Rect2(heartX, 0, 17, 16)
	healthTexture.region = Rect2(heartX,0,17,16)

func _ready():
	if healthTexture:
		healthTexture = healthTexture.duplicate()
		healthTexture.region = Rect2(0,0,17,16)
	
