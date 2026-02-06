extends Node

signal coins_changed(new_coins: int)

var coins: int = 0

func reset() -> void:
	coins = 0
	emit_signal("coins_changed", coins)

func add_coins(amount: int) -> void:
	coins += amount
	emit_signal("coins_changed", coins)
