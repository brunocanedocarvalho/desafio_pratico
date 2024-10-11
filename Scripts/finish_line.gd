extends Area2D

const SPEED = 100.0
var player
var is_moving = true

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	player = $"../Player"

func _physics_process(delta: float) -> void:
	if is_moving and not player.is_control_disabled:
		position.y += SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		is_moving = false
