extends Area2D

signal blue_potion

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PotionBlue_body_entered(body):
	if body.name == "Princess":
		emit_signal("blue_potion")
		queue_free()
