extends Area2D

var screensize = Vector2.ZERO


export var cohesion_on = false
export var separation_on = false
export var alignment_on = false

var separation = 1000
var speed = 4

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

var is_flying = false

var flockmates = []

onready var radius = $CollisionShape2D.shape.get_radius()


onready var all_boids = get_parent().all_boids

func _ready():
	randomize()
	screensize = get_viewport_rect().size
	velocity = Vector2(rand_range(-speed, speed) , rand_range(-speed, speed))

func _input(event):
	if event is InputEventKey and Input.is_action_just_pressed("ui_accept"):
		is_flying = !is_flying
		if is_flying:
			$AnimatedSprite.play('fly')
		else:
			$AnimatedSprite.play('default')
			
func _process(delta):
	if is_flying:
		fly(delta)
		
func fly(delta):
	
	check_sky(all_boids)
	
	flock()
	move(delta)

	# velocity = velocity.normalized() * speed * delta
	#rotation = lerp_angle(rotation, velocity.angle_to_point(Vector2.ZERO), 0.4)

func check_sky(all_boids):
	for boid in all_boids:
		if can_see(boid):
			flockmates.append(boid)
			
func flock():
	
	if alignment_on:
		var alignment = align(flockmates)
		acceleration = alignment
	

func align(flockmates):
	var desired_velocity = Vector2.ZERO
	var total = 0
	for boid in flockmates:
		if not boid == self and can_see(boid):
			desired_velocity += boid.velocity
			total += 1
	
	if total == 0:
		return desired_velocity
	
	desired_velocity /= total
	desired_velocity -= velocity
	
	return desired_velocity
	
func move(delta):
	velocity += acceleration
	position += velocity 
	
	# wrap_screen_if_needed()

func can_see(boid):

	return position.distance_to(boid.position) < radius

#func check_neighbors() -> void:
#	if neighbors:
#		var count = neighbors.size()
#
#		var stay_away = Vector2.ZERO
#		var avg_vel = Vector2.ZERO
#		var avg_pos = Vector2.ZERO
#
#
#		for n in neighbors:
#			check_separation()
#
#			stay_away -= (n.global_position - global_position) * (distance /1.0001*(global_position - n.global_position).length())
#			avg_vel += n.velocity
#			avg_pos += n.position
#
#		avg_pos /= count
#		velocity += (avg_pos - position)
#		avg_vel /= count
#		velocity += (avg_vel - velocity) / 2
#		stay_away /= count
#		velocity += stay_away
#




	

	
	
func wrap_screen_if_needed():
	if global_position.x < 0:
		global_position.x = screensize.x
	if global_position.x > screensize.x:
		global_position.x = 0
	if global_position.y < 0:
		global_position.y = screensize.y
	if global_position.y > screensize.y:
		global_position.y = 0


#func check_separation():
#	var total = 0
#	var steering = Vector2.ZERO
#
#	for boid in flock:
#		var dist = position.distance_to(boid.position)
#		if not boid is self and dist < radius:
#			var temp = SubVectors(self.position,mate.position)
#			temp = temp/(dist * 2)
#			steering += temp
#			total += 1
#
#	if total > 0:
#		steering = steering / total
#		# steering = steering - self.position
#		steering.normalize()
#		steering = steering * self.max_speed
#		steering = steering - self.velocity
#		steering.limit(self.max_length)
#
#	return steering
#def alignment(self, flockMates):
#	total = 0
#	steering = Vector()
#	# hue = uniform(0, 0.5)
#	for mate in flockMates:
#		dist = getDistance(self.position, mate.position)
#		if mate is not self and dist < self.radius:
#			vel = mate.velocity.Normalize()
#			steering.add(vel)
#			mate.color = hsv_to_rgb( self.hue ,1, 1)
#
#			total += 1
#
#
#		if total > 0:
#			steering = steering / total
#			steering.normalize()
#			steering = steering * self.max_speed
#			steering = steering - self.velocity.Normalize()
#			steering.limit(self.max_length)
#		return steering
#
#	def cohesion(self, flockMates):
#		total = 0
#		steering = Vector()
#
#		for mate in flockMates:
#			dist = getDistance(self.position, mate.position)
#			if mate is not self and dist < self.radius:
#				steering.add(mate.position)
#				total += 1
#
#		if total > 0:
#			steering = steering / total
#			steering = steering - self.position
#			steering.normalize()
#			steering = steering * self.max_speed
#			steering = steering - self.velocity
#			steering.limit(self.max_length)
#
#		return steering
