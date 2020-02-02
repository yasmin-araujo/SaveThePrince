extends Node

signal next_level

var blocked = true
var num_keys = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _on_Key_has_key():
	if(Global.level == 1):
		num_keys = 1
		
	if(num_keys == Global.keys):
		blocked = false

func _on_Portal_body_entered(body):
	if(blocked == false):
		emit_signal("next_level")