extends Area2D

const SPEED = 100.0
var player
var panel

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	player = $"../Player"
	panel = $"../Panel"

func _physics_process(delta: float) -> void:
	if not player.is_control_disabled and not panel.is_fuel_zero:
		position.y += SPEED * delta

	if position.y > 720:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("apply_car_knockback"):
		var knockback_direction = (body.global_position - global_position).normalized()
		body.apply_car_knockback(knockback_direction)
