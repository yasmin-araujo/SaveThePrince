extends Node

onready var coin = preload("res://Coin.tscn")

var coins = Global.coins
var lives = Global.lives
var score = Global.score
var keys = Global.keys

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameSound.play()
	Global.level = 2
	$HUD.update_coins(coins, "65")
	$HUD.update_lives(lives)
	$HUD.update_score(score)
	$HUD.update_keys(keys, "3")
	$Beach/PotionBlue.hide()
	$Beach/Coin3.hide()
	$Beach/Coin4.hide()
	$Beach/Key2.hide()
	$Beach/Coin8.hide()
	$Beach/PotionBlue.set_collision_layer_bit(0, false)
	$Beach/Coin3.set_collision_layer_bit(0, false)
	$Beach/Coin4.set_collision_layer_bit(0, false)
	$Beach/Key2.set_collision_layer_bit(0, false)
	$Beach/Coin8.set_collision_layer_bit(0, false)
	
func _on_Coin_add_coin():
	$CoinSound.play()
	coins += 1
	score += 5
	#print("Moeda")
	$HUD.update_coins(coins, "65")
	$HUD.update_score(score)
	#print(coins)

func _on_Key_has_key():
	keys += 1
	score += 10
	#print("Chave")
	$HUD.update_keys(keys, "3")
	$HUD.update_score(score)
	
func _on_Heart_add_life():
	lives += 1
	$HUD.update_lives(lives)

func _on_Goblin_damage():
	damage()

func _on_Gargoyle_damage():
	damage()

func _on_Spikes_damage():
	damage()

func _on_GoblinArcher_damage():
	damage()

func _on_Princess_shooted():
	damage()
	
func damage():
	$Princess/HitTimer.stop()
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
	enemy_dead()
	
func _on_Gargoyle_enemy_dead():
	enemy_dead()

func _on_GoblinArcher_enemy_dead():
	enemy_dead()

func enemy_dead():
	score += 50
	$HUD.update_score(score)

func _on_Tresure_open_tresure():#passagem secreta
	$Beach/PotionBlue.show()
	$Beach/Coin3.show()
	$Beach/Coin4.show()
	$Beach/PotionBlue.set_collision_layer_bit(0, true)
	$Beach/Coin3.set_collision_layer_bit(0, true)
	$Beach/Coin4.set_collision_layer_bit(0, true)

func _on_Tresure2_open_tresure():#salinha do precipicio
	$Beach/Key2.show()
	$Beach/Coin8.show()
	$Beach/Key2.set_collision_layer_bit(0, true)
	$Beach/Coin8.set_collision_layer_bit(0, true)

func _on_Prince_endgame():
	$HUD.victory()
	$VictorySound.play()
	get_tree().paused = true