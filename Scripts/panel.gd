extends Panel

var fuel: int = 20
var is_fuel_zero: bool = false  # Flag que indica se o combustível chegou a 0

func _ready() -> void:
	$FuelCounter.text = "Fuel: " + str(fuel)
	$Timer.start()

func _on_timer_timeout() -> void:
	if not is_fuel_zero:
		fuel -= 2
		if fuel <= 0:
			fuel = 0
			is_fuel_zero = true
	$FuelCounter.text = "Fuel: " + str(fuel)

func add_fuel(amount: int) -> void:
	if not is_fuel_zero:
		fuel += amount
		$FuelCounter.text = "Fuel: " + str(fuel)
