extends CharacterBody2D

@onready var target: CharacterBody2D = $"../MainPlayer"

var speed = 150

func _physics_process(delta: float) -> void:
	var direction = (target.position - position).normalized()
	velocity = speed * direction
	look_at(target.position)
	move_and_slide()
