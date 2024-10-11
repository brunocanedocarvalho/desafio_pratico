extends Area2D

const FALL_SPEED = 100.0
var panel: Node
var player: Node

func _ready() -> void:
	panel = $"../Panel"
	player = $"../Player"

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		panel.add_fuel(7)
		print("+7 fuel")
		queue_free()

func _physics_process(delta: float) -> void:
	if panel.fuel > 0 and not player.is_control_disabled:
		position.y += FALL_SPEED * delta

	if position.y > 720:
		queue_free()
