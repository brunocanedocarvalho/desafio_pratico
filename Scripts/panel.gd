extends Panel

var fuel: int = 100

func _ready() -> void:
	$FuelCounter.text = "Fuel: " + str(fuel)
	$Timer.start()

func _on_timer_timeout() -> void:
	fuel -= 2
	if fuel < 0:
		fuel = 0
	$FuelCounter.text = "Fuel: " + str(fuel)

func add_fuel(amount: int) -> void:
	fuel += amount
	$FuelCounter.text = "Fuel: " + str(fuel)
