extends CharacterBody2D

#Variables

@export var speed = 300
var character_direction : Vector2 = Vector2.ZERO

	
func _physics_process(delta):
	character_direction.x = Input.get_axis("ui_left", "ui_right")
	character_direction.y = Input.get_axis("ui_up", "ui_down")
	
	if character_direction.x > 0:
		$AnimatedSprite2D.flip_h = false
	if character_direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	
	if character_direction:
		velocity = character_direction * speed
		if $AnimatedSprite2D.animation != "Walking":
			$AnimatedSprite2D.animation = "Walking"
	
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		if $AnimatedSprite2D.animation != "Idle":
			$AnimatedSprite2D.animation = "Idle"
		
		
	move_and_slide()
