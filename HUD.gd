extends CanvasLayer

func _ready():
	$GameOver.visible = false
	$GameOverLabel.visible = false
	$EndGameLabel.visible = false
	$PlayAgainButton.visible = false
	$PlayAgainButton.disabled = true

func end_game():
	$GameOver.visible = true
	$GameOverLabel.visible = true
	$PlayAgainButton.visible = true
	$PlayAgainButton.disabled = false
	
func victory():
	$GameOver.visible = true
	$EndGameLabel.visible = true
	$PlayAgainButton.visible = true
	$PlayAgainButton.disabled = false

func update_score(value):
	$ScoreLabel.text = formate(value, 4);
	Global.score = value

func update_coins(value, total_value):
	$CoinLabel.text = formate(value, 2) + "/" + formate(total_value, 2);
	Global.coins = value

func update_lives(value):
	if(value < 0):
		value = 0
	$LifeLabel.text = formate(value, 2);
	Global.lives = value
	
func update_keys(value, total_value):
	$KeyLabel.text = formate(value, 2) + "/" + formate(total_value, 2);
	Global.keys = value
	
func formate(value, size):
	var res = ""
	var svalue = str(value)
	#print (svalue, len(svalue), size)
	if len(svalue) < size:
		
		for i in (size - len(svalue)):
			res += "0"
	res += str(value)
	return res

func _on_Button_button_up():
	Global.coins = 0
	Global.lives = 3
	Global.score = 0
	Global.keys = 0
	print("REPLAY")
	get_tree().change_scene("Level1.tscn")
	get_tree().paused = false