extends Node2D

var BoidScene  = preload("res://Boid.tscn")

var screen_size

var all_boids = []

func _ready():
	screen_size = get_viewport_rect().size
	
	for x in range(screen_size.x):
		for y in range(screen_size.y):
			if randf()<0.00002:
			#if x % 150 == 0 and y % 120 == 0 :
				var boid = BoidScene.instance()
				boid.position = Vector2(x, y)
				all_boids.append(boid)
				add_child(boid)
