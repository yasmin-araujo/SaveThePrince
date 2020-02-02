extends Area2D

const VELOCITY = Vector2(-300, 0)

func _ready():
	global_position.y += 0

func _process(delta):
	move(delta)
	removeWhenOffScreen()

func move(delta):
	global_position += VELOCITY * delta

func removeWhenOffScreen():
	if global_position.x < 0:
		queue_free()

func _on_Arrow_body_entered(body):
	var nome = ""
	if (len(body.name) >= 12):
		for i in range(12):
			nome += body.name[i]
	if nome != "GoblinArcher":
		hide()
		$CollisionShape2D.call_deferred("disabled", true) #mudar a variavel disabled para true quando puder
		set_collision_mask_bit(0, false)
		set_collision_mask_bit(1, false)
