extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const VELOCITY = Vector2(300, 0)

func _ready():
	global_position.y += 10

func _process(delta):
	move(delta)
	removeWhenOffScreen()

func move(delta):
	global_position += VELOCITY * delta

func removeWhenOffScreen():
	if global_position.x > 4000:
		queue_free()

func _on_Fireball_body_entered(body):
	if body.name != "Princess":
		queue_free()
		#hide()
		#$CollisionShape2D.call_deferred("disabled", true) #mudar a variavel disabled para true quando puder
		set_collision_mask_bit(0, false)
		set_collision_mask_bit(1, false)
		set_collision_mask_bit(2, false)