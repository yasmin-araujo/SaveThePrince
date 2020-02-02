extends KinematicBody2D

onready var fireball = preload("res://DragonAttack.tscn")
const RELOAD_TIME = 0.8
var reloading = 0.0
const ATTACK_TIME = 0.3 
var reload_attack = 0.0
var target
var targetnome
var hit_pos
var dentro = false
var die = false
var lives = 10
var rot = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	reloading -= delta
	reload_attack -= delta
	
	if die == false:
		if dentro == true:
			aim()
			#print(target)
		else:
			#print("FLY")
			fly() 

func aim():
	#print("alo1")
	hit_pos = []
	var space_state = get_world_2d().direct_space_state
	#print(target.position)
	var pos = target.position
	#print("alo2")
	var result = space_state.intersect_ray(position,
			pos, [self], collision_mask)
	#print(result)
	if result:
		#print("alo3")
		hit_pos.append(result.position)
		if result.collider.name == "Princess":
			#print("alo4")
			rot = (target.position + position).angle()
			rotation = rot 
			$LifeLabel.set_rotation(-rot)
#			$AnimatedSprite.flip_h = false
#			$AnimatedSprite.flip_v = true
#				if can_shoot:
			fire(pos)
			#break
		
func fire(pos):
	if $AnimatedSprite.animation != "Attack":
		$AnimatedSprite.animation = "Attack"
	if reloading > 0.5 && ((reload_attack > 0.1 && reload_attack <= 0.15) || (reload_attack > 0.2 && reload_attack <= 0.25)):
			var fb = fireball.instance()
			var a = (pos - global_position).angle()
			fb.start(global_position, a + rand_range(-0.05, 0.05))
			#fb.global_position = global_position
			get_parent().add_child(fb)
	elif (reloading < 0):	
		reloading = RELOAD_TIME	
	
	if reload_attack <= 0:
		reload_attack = ATTACK_TIME
		
func fly():
	if $AnimatedSprite.animation != "Fly":
		$AnimatedSprite.animation = "Fly"
		rotation_degrees = 0
		$LifeLabel.set_rotation(rot)
	
func _on_FireArea2D_body_entered(body):
	#print("entrouuu")
	#print(body.name)
	dentro = true
#	if(body.name != "Dragon"):
	target = body
	targetnome = body.name

func _on_FireArea2D_body_exited(body):
	if (body.name != "Dragon"):
		#print("saiuuu", body.name)
		dentro = false
#		if body == target:
#			print("null")
		target = null
		targetnome = null
#			fly() 

func _on_DragonArea2D_area_entered(area):
	if (die == false):
		var nome = ""
		for i in range(0,len(area.name),1):
			if(area.name[0] == "@" && i > 0 && i < 12):
				nome += area.name[i]
			elif(area.name[0] != "@" && i < 11):
				nome += area.name[i]
		#print(nome, lives)
		if(nome == "IceballRigh" or nome == "IceballLeft"):
			lives -= 2
		elif (nome == "FireballRig" or nome == "FireballLef"):
			lives -= 1
		if(lives < 0):
			lives = 0;
		update_lives()
		if lives <= 0:
			$DieTimer.start()
			rotation_degrees = 0
			$LifeLabel.set_rotation(rot)
			die = true
			$AnimatedSprite.animation = "Die"
			emit_signal("enemy_dead")

func _on_DieTimer_timeout():
	queue_free()

func update_lives():
	var l = "Lives:  "
	l += String(lives)
	$LifeLabel.text = l