extends CharacterBody2D

var fuel_counter: Label
var timer: Timer
var wall_timer: Timer

const SPEED = 70.0
var is_control_disabled = false
var is_colliding_with_wall = false
var knockback_force = Vector2.ZERO
const KNOCKBACK_STRENGTH = 500.0
const KNOCKBACK_DECAY = 500.0

func _ready():
	fuel_counter = get_node("/root/Game/Panel/FuelCounter")
	timer = get_node("/root/Game/Panel/Timer")
	
	wall_timer = Timer.new()
	wall_timer.wait_time = 3.0
	wall_timer.one_shot = true
	add_child(wall_timer)

	if timer:
		timer.start()

func _process(delta: float) -> void:
	if is_control_disabled:
		velocity = knockback_force
		knockback_force = knockback_force.move_toward(Vector2.ZERO, KNOCKBACK_DECAY * delta)
		
		if wall_timer.time_left == 0:
			is_control_disabled = false
			is_colliding_with_wall = false
	else:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		velocity.y = 0

		# Verifica colisão com as paredes
		if is_on_wall() and not is_colliding_with_wall:
			_on_collision_with_wall()

	move_and_slide()

func _on_collision_with_wall():
	is_control_disabled = true
	is_colliding_with_wall = true
	
	if position.x < 100:  # Colisão com a parede da esquerda
		knockback_force = Vector2(KNOCKBACK_STRENGTH, 0)
	else:  # Colisão com a parede da direita
		knockback_force = Vector2(-KNOCKBACK_STRENGTH, 0) # to do: fix colisão com parede direita

	_reduce_fuel(5)
	wall_timer.start()

func _reduce_fuel(amount: int) -> void:
	var panel = get_node("/root/Game/Panel")
	panel.add_fuel(-amount)

func apply_knockback(knockback_direction: Vector2) -> void:
	is_control_disabled = true
	knockback_force = Vector2(knockback_direction.x, 0) * KNOCKBACK_STRENGTH
