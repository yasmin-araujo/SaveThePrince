extends StaticBody2D

signal open_tresure

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_TresureArea2D_area_entered(area):
	if area.name == "FireballRight" || area.name == "FireballLeft" || area.name == "IceRight" || area.name == "IceballLeft" :
		emit_signal("open_tresure")
		queue_free()
