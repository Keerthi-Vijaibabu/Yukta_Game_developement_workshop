extends Label

func _ready() -> void:
	text = "Coins: %d" % ScoreManager.coins
	ScoreManager.coins_changed.connect(_on_coins_changed)

func _on_coins_changed(new_coins: int) -> void:
	text = "Coins: %d" % new_coins
