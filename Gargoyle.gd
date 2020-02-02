extends KinematicBody2D

signal damage
signal enemy_dead

const GRAVITY = 1000.0 # pixels/second/second

const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 10
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 80
const STOP_FORCE = 1300
const JUMP_SPEED = 320
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()

#var limit = [1860,500]

var walk_left = true
var walk_right = false
var die = false
var stop = true

var lives = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	$GargoyleTimer.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var force = Vector2(0, 0)#Vector2(0, GRAVITY)
	
	stop = true
	
	if walk_left:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			$GargoyleSprite.flip_h = true
			if (die == false):
				$GargoyleSprite.animation = "Fly"
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			$GargoyleSprite.flip_h = false
			if (die == false):
				$GargoyleSprite.animation = "Fly"
			force.x += WALK_FORCE
			stop = false
	
	if stop:
		if (die == false):
			$GargoyleSprite.animation = "Stop"
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	
	if(die == true):
		force = Vector2(0, GRAVITY)
		#print(die)
	
	# Integrate forces to velocity
	velocity += force * delta	
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	#position.x = clamp(position.x, 10, limit[0]) 
	#position.y = clamp(position.y, 0, limit[1])

func _on_GargoyleTimer_timeout():
	$GargoyleTimer.stop()
	if die == true:
		walk_right = false
		walk_left = false
	else:
		walk_right = walk_left
		walk_left = not walk_right
		$GargoyleTimer.start()

func _on_GargoyleArea2D_body_entered(body):
	if body.name == "Princess":
		emit_signal("damage")

func _on_DieTimer_timeout():
	queue_free()
	
func _on_GargoyleArea2D_area_entered(area):
	if (die == false):
		var nome = ""
		for i in range(0,len(area.name),1):
			if(area.name[0] == "@" && i > 0 && i < 12):
				nome += area.name[i]
			elif(area.name[0] != "@" && i < 11):
				nome += area.name[i]
		if(nome == "IceballRigh" or nome == "IceballLeft"):
			lives -= 2
		elif (nome == "FireballRig" or nome == "FireballLef"):
			lives -= 1
		if(lives < 0):
			lives = 0;
		update_lives()
		if(lives <= 0):
			$DieTimer.start()
			die = true
			$GargoyleSprite.animation = "Die"
			emit_signal("enemy_dead")
			
func update_lives():
	var l = "Lives:  "
	l += String(lives)
	$LifeLabel.text = l