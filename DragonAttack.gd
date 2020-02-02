extends Area2D

const VELOCITY = Vector2(300, 0)
var speed = 210
var velocity = Vector2()

func _ready():
	global_position.y += -10
	global_position.x += -120

func _process(delta):
	move(delta)
	removeWhenOffScreen()
	
func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)

func move(delta):
	#global_position += VELOCITY * delta
	position += velocity * delta

func removeWhenOffScreen():
	if global_position.y < 0:
		queue_free()
	
func _on_DragonAttack_body_entered(body):
	if body.name != "Dragon":
		hide()
		$CollisionShape2D.call_deferred("disabled", true) #mudar a variavel disabled para true quando puder
		set_collision_mask_bit(0, false)
		set_collision_mask_bit(1, false)
		set_collision_mask_bit(2, false)
