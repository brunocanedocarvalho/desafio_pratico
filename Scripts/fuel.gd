extends Area2D

const FALL_SPEED = 100.0
var panel
var player

func _ready() -> void:
	panel = get_node("/root/Game/Panel")
	player = get_node("/root/Game/Player")

func _on_body_entered(body: Node2D) -> void:
	panel.add_fuel(7)
	print("+7 fuel")
	queue_free()

func _physics_process(delta: float) -> void:
	# Se o movimento do carro estiver desativado, o combustível não cai
	if not player.is_control_disabled:
		position.y += FALL_SPEED * delta

	if position.y > 720:
		queue_free()
