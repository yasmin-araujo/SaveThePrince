extends Node

var coins = Global.coins
var lives = Global.lives
var score = Global.score
var keys = Global.keys

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameSound.play()
	Global.level = 1
	$HUD.update_coins(coins, "12")
	$HUD.update_lives(lives)
	$HUD.update_score(score)
	$HUD.update_keys(keys, "1")

func _on_Coin_add_coin():
	$CoinSound.play()
	coins += 1
	score += 5
	#print("Moeda")
	$HUD.update_coins(coins, "12")
	$HUD.update_score(score)

func _on_Key_has_key():
	keys += 1
	score += 10
	#print("Chave")
	$HUD.update_keys(keys, "1")
	$HUD.update_score(score)

func _on_Goblin_damage():
	$Princess/HitTimer.start()
	lives -= 1
	$HUD.update_lives(lives)
	if (lives == 0):
		$Princess.death()

func _on_Princess_dead():
	$GameSound.stop()
	$GameOverSound.play()
	$HUD.end_game()
	get_tree().paused = true

func _on_Goblin_enemy_dead():
	score += 50
	$HUD.update_score(score)

func _on_Portal_next_level():
	Global.keys = 0
	Global.coins = 0
	get_tree().change_scene("Level2.tscn")