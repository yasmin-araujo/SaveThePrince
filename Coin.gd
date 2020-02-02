extends Area2D

signal add_coin

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Coin_body_entered(body):
	if(body.name == "Princess"):
		emit_signal("add_coin")
		queue_free()
		#hide() #faz ele sumir
		#$CollisionShape2D.call_deferred("disabled", true) #mudar a variavel disabled para true quando puder
		#set_collision_layer_bit(0, false)