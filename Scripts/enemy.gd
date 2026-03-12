extends Area2D

var is_aimed : bool = false
var points : int = 100
var health : int = 10
signal is_shot(points)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(damage: int):
	if is_aimed:
		health -= damage
		if check_if_dead():
			is_shot.emit(points)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_aimed = true
	pass # Replace with function body.

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_aimed = false
	pass # Replace with function body.

func check_if_dead() -> bool:
	if health < 0:
		return true
	return false
