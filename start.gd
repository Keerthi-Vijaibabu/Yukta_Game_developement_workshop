extends Control


func _on_start_pressed() :
	get_tree().change_scene_to_file("res://world.tscn")


func _on_options_pressed() :
	print("settings")


func _on_exit_pressed() :
	get_tree().quit()
	


func _on_pressed_game_over() -> void:
	get_tree().change_scene_to_file("res://start.tscn")
