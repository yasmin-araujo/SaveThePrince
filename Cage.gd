extends RigidBody2D

var blocked = true
var num_keys = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _on_Key_has_key():
	if(Global.level == 2):
		num_keys = 3
		
	if(num_keys == Global.keys):
		blocked = false

func _on_Cage_body_entered(body):
	print(blocked, num_keys, Global.keys)
	if(blocked == false):
		queue_free()