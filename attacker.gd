extends CharacterBody2D

@onready var target: CharacterBody2D = $"../MainPlayer"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_cd: Timer = $"attackCoolDown Timer"

var speed := 110
var chasing := false
var in_attack_range := false
var damage := 10

func _physics_process(delta: float) -> void:
	if not chasing:
		velocity = Vector2.ZERO
		sprite.play("idle")
		return

	# If close enough, stop and attack
	if in_attack_range:
		velocity = Vector2.ZERO
		sprite.play("attack")
		try_attack()
		return

	# Otherwise, chase
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * speed
	sprite.play("walking")
	move_and_slide()

func try_attack() -> void:
	if attack_cd.is_stopped():
		attack_cd.start()
		# Deal damage (requires player to implement take_damage)
		if is_instance_valid(target) and target.has_method("take_damage"):
			target.take_damage(damage)


func _on_range_body_entered(body: Node2D) -> void:
	if body  == target:
		chasing = true
	


func _on_range_body_exited(body: Node2D) -> void:
	if body  == target:
		chasing = false
		


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body  == target:
		in_attack_range = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body  == target:
		in_attack_range = false
