extends CharacterBody2D

#Variables

@export var speed = 300
var character_direction : Vector2 = Vector2.ZERO
@onready var player_hp_bar: ProgressBar = $PlayerHpBar

@export var max_hp = 100
var hp := 100


@onready var attack_hit_box = $AttackHitBox/CollisionShape2D
@onready var attack_cool_down = $attackCoolDown
var damage = 15
var attacking = false

#player hp bar
@onready var hp_bar: ProgressBar = $PlayerHpBar
@onready var heal = $heal

func _ready() -> void:
	$AnimatedSprite2D.play("Idle")
	attack_hit_box.disabled = true

func _physics_process(delta):
	
	if heal.is_stopped() && hp < 100: #To increase health
		hp+=1
		heal.start()
		hp_bar.value = hp
	
	if Input.is_action_just_pressed("attack"):
		start_attack()
	
	if attacking == false:
		character_direction.x = Input.get_axis("ui_left", "ui_right")
		character_direction.y = Input.get_axis("ui_up", "ui_down")
		
		if character_direction.x > 0:
			$AnimatedSprite2D.flip_h = false
		if character_direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		
		if character_direction:
			velocity = character_direction * speed
			if $AnimatedSprite2D.animation != "Walking":
				$AnimatedSprite2D.play("Walking")
		
		else:
			velocity = velocity.move_toward(Vector2.ZERO, speed)
			if $AnimatedSprite2D.animation != "Idle":
				$AnimatedSprite2D.animation = "Idle"
	
	
		
	move_and_slide()


func take_damage(amount: int) -> void:	
	hp = max(hp - amount, 0)
	hp_bar.value = hp

	if hp <= 0:
		die()

func die() -> void:
	print("player dead")
	queue_free()


func start_attack() -> void:
	if attacking:
		return
		
	if not attack_cool_down.is_stopped():
		return

	attacking = true
	attack_cool_down.start()
	
	print("got attack signal")
	$AnimatedSprite2D.play("attack")

	# Enable hitbox briefly (hit window)
	attack_hit_box.disabled = false
	await get_tree().create_timer(0.12).timeout  # hit active time
	attack_hit_box.disabled = true

	# Wait until animation ends (optional but nice)
	await $AnimatedSprite2D.animation_finished
	attacking = false


func _on_attack_hit_box_body_entered(body):
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
