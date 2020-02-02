extends KinematicBody2D

onready var arrow = preload("res://Arrow.tscn")

signal damage
signal enemy_dead

const GRAVITY = 500.0 # pixels/second/second

const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 10
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 60
const STOP_FORCE = 1300
const JUMP_SPEED = 320
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()

var limit = [1860,500]

var walk_left = false
var walk_right = false
var die = false
var stop = true

var lives = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$GoblinArcherTimer.start()

func _physics_process(delta):
	pass

func _on_GoblinTimer_timeout():
	$GoblinArcherTimer.stop()
	var a = arrow.instance()
	a.global_position = global_position
	get_parent().add_child(a)
	$GoblinArcherTimer.start()

func _on_GoblinArea2D_body_entered(body):
	if body.name == "Princess":
		emit_signal("damage")

func _on_DieTimer_timeout():
	queue_free()
	
func _on_GoblinArea2D_area_entered(area):
	if(die == false):
		var nome = ""
		for i in range(0,len(area.name),1):
			if(area.name[0] == "@" && i > 0 && i < 6):#é cópia da flecha
				nome += area.name[i]
			elif(area.name[0] != "@"):
				nome += area.name[i]
		if ("Arrow" != nome):
			nome = ""
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
			if lives <= 0:
				$DieTimer.start()
				die = true
				$GoblinArcherSprite.animation = "Die"
				emit_signal("enemy_dead")

func update_lives():
	var l = "Lives:  "
	l += String(lives)
	$LifeLabel.text = l