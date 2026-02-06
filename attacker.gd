extends CharacterBody2D

@onready var target: CharacterBody2D = $"../MainPlayer"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_cd: Timer = $"attackCoolDown"

var speed := 110
var chasing := false
var in_attack_range := false
var damage := 5
var hp := 50

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
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	velocity = direction * speed
	sprite.play("walking")
	move_and_slide()
		

func try_attack() -> void:
	if attack_cd.is_stopped():
		print("attack started")
		attack_cd.start()
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
		#print("Range entered")
		in_attack_range = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body  == target:
		in_attack_range = false


func take_damage(amount: int) -> void:
	hp -= amount
	print("Enemy HP:", hp)

	if hp <= 0:
		die()

func die() -> void:
	queue_free()
