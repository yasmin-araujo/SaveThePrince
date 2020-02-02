extends KinematicBody2D

#export (PackedScene) var fireball #instancia obj a partir da cena
onready var fireballLeft = preload("res://FireballLeft.tscn")
onready var fireballRight = preload("res://FireballRight.tscn")
onready var iceballLeft = preload("res://IceballLeft.tscn")
onready var iceballRight = preload("res://IceballRight.tscn")

# This demo shows how to build a kinematic controller.
signal dead
signal shooted

# Member variables
const GRAVITY = 500.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 320
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

const RELOAD_TIME = 0.4
var reloading = 0.0

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var walking = false

var prev_jump_pressed = false
var limit = [1860,500] #950, 500
var time = 0
var hit = false
var die = false
var attack = false
var blue = false

func _process(delta):
    reloading -= delta

func _physics_process(delta):
	# Create forces
	var force = Vector2(0, GRAVITY)
	
	var walk_left = Input.is_action_pressed("ui_left")
	var walk_right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("ui_up")
	var attacking = Input.is_action_pressed("ui_select")
	
	var stop = true
	
	if (walk_left == false && walk_right == false):
		walking = false;
	
	if (die == true):
		walk_left = false
		walk_right = false
		jump = false
		attacking = false
	
	if walk_left:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			if (jumping == false && hit == false && die == false && attack == false):
				walking = true
				walk()
			$PrincessSprite.flip_h = true;
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			if (jumping == false && hit == false && die == false && attack == false):
				walking = true
				walk()
			$PrincessSprite.flip_h = false;
			force.x += WALK_FORCE
			stop = false
	
	if stop:
		if (walking == false && jumping == false && hit == false && die == false && attack == false):
			$PrincessSprite.animation = "Stop"
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	# Integrate forces to velocity
	velocity += force * delta	
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		on_air_time = 0
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		$PrincessSprite.animation = "Jump"
		velocity.y = -JUMP_SPEED
		jumping = true
		stop = false
	
	on_air_time += delta
	prev_jump_pressed = jump
	
	if attacking:
		attack = true
		$AttackTimer.start()
		$PrincessSprite.animation = "Attack"
		stop = false
		fire()
	
	#position.x = clamp(position.x, 10, limit[0]) 
	#position.y = clamp(position.y, 0, limit[1])
		
func walk():
	if($PrincessSprite.animation != "Walk"):
		$PrincessSprite.animation = "Walk"

func _on_HitTimer_timeout():
	print("hit")
	hit = true
	if (die == false):
		$PrincessSprite.animation = "Hit"
	$PrincessSprite.visible = ! $PrincessSprite.visible
	time += 1
	if time == 6:
		$HitTimer.stop()
		hit = false
	elif time > 6:
		time = 1
		
func death():
	die = true
	$PrincessSprite.animation = "Die"
	$DieTimer.start()

func _on_DieTimer_timeout():
	emit_signal("dead")

func _on_AttackTimer_timeout():
	attack = false
	$AttackTimer.stop()

func fire():
	if reloading <= 0.0:
		var fb
		if $PrincessSprite.flip_h == false:
			if blue == false:
				fb = fireballRight.instance()
			elif blue == true:
				fb = iceballRight.instance()
		elif $PrincessSprite.flip_h == true:
			if blue == false:
				fb = fireballLeft.instance()
			elif blue == true:
				fb = iceballLeft.instance()
		fb.global_position = global_position
		get_parent().add_child(fb)
		reloading = RELOAD_TIME

func _on_PotionBlue_blue_potion():
	$PowerTimer.start()
	blue = true

func _on_PowerTimer_timeout():
	blue = false

func _on_Area2D_area_entered(area):
	#print(area.name)
	var nome = ""
	for i in range(0,len(area.name),1):
		if(area.name[0] == "@" && i > 0 && i < 6):#é cópia da flecha
			nome += area.name[i]
		elif(area.name[0] != "@"):
			nome += area.name[i]
	print(nome)
	if nome == "Arrow" || nome == "Drago":
		emit_signal("shooted")
