extends Area2D

const SPEED = 100.0
var player

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	player = get_node("/root/Game/Player")

func _physics_process(delta: float) -> void:
	# Se o movimento do carro estiver desativado, o BlueCar não se move
	if not player.is_control_disabled:
		position.y += SPEED * delta

	if position.y > 720:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	var knockback_direction = (body.global_position - global_position).normalized()
	var knockback_strength = 100.0
	var knockback_force = knockback_direction * knockback_strength

	body.apply_knockback(knockback_force)
