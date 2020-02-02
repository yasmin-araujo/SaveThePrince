extends Area2D

signal has_key

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Key_body_entered(body): #body é obj que colidiu com a area
	hide() #faz ele sumir
	emit_signal("has_key")
	$CollisionShape2D.call_deferred("disabled", true) #mudar a variavel disabled para true quando puder
	set_collision_layer_bit(0, false)