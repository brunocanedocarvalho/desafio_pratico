extends CharacterBody2D

const SPEED = 70.0
const KNOCKBACK_STRENGTH_WALL = 50.0  # Knockback ao colidir com paredes
const KNOCKBACK_STRENGTH_CAR = 1000.0  # Knockback ao colidir com carros
const KNOCKBACK_DECAY = 500.0  # A taxa de redução do knockback

var is_control_disabled = false
var knockback_force = Vector2.ZERO
var is_colliding_with_wall = false

var fuel_counter: Label
var timer: Timer
var wall_timer: Timer

func _ready() -> void:
	fuel_counter = $"../Panel/FuelCounter"
	timer = $"../Panel/Timer"
	
	wall_timer = Timer.new()
	wall_timer.wait_time = 3.0
	wall_timer.one_shot = true
	add_child(wall_timer)

	if timer:
		timer.start()

func _process(delta: float) -> void:
	# Controla a lógica do knockback ou o movimento do jogador
	if is_control_disabled:
		_process_knockback(delta)
	else:
		_process_movement()

	move_and_slide()

func _process_movement() -> void:
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	velocity.y = 0

	_check_wall_collision()

# Lógica de colisão com paredes
func _check_wall_collision() -> void:
	if is_on_wall() and not is_colliding_with_wall:
		is_control_disabled = true
		is_colliding_with_wall = true

		# Define a direção do knockback com base na posição do carro (esquerda ou direita)
		if position.x < 100:  # Parede esquerda
			knockback_force = Vector2(KNOCKBACK_STRENGTH_WALL, 0)
		else:  # Parede direita
			knockback_force = Vector2(-KNOCKBACK_STRENGTH_WALL, 0)

		# Reduz o combustível ao colidir
		_reduce_fuel(5)

		# Inicia o timer de recuperação após a colisão
		wall_timer.start()

# Lógica para processar o knockback do carro
func _process_knockback(delta: float) -> void:
	# Aplica a força de knockback ao movimento
	velocity = knockback_force
	# Gradualmente reduz o knockback para zero no eixo X e mantém o Y em zero
	knockback_force = knockback_force.move_toward(Vector2.ZERO, KNOCKBACK_DECAY * delta)

	# Reativa o controle do carro quando o timer terminar
	if wall_timer.time_left == 0:
		is_control_disabled = false
		is_colliding_with_wall = false

# Função para aplicar knockback após colisão com outros carros
func apply_knockback(knockback_direction: Vector2) -> void:
	is_control_disabled = true
	# Aplica uma força de knockback mais forte para colisão com carros, com Y sempre zero
	knockback_force = Vector2(knockback_direction.x, 0) * KNOCKBACK_STRENGTH_CAR

# Função para reduzir o combustível
func _reduce_fuel(amount: int) -> void:
	# Acessa o painel e reduz o combustível
	var panel = $"../Panel"
	panel.add_fuel(-amount)
