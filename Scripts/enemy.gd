extends Area2D

var is_aimed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		take_damage()
	pass

func take_damage():
	if is_aimed:
		print("You did it!!")

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_aimed = true
	pass # Replace with function body.

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_aimed = false
	pass # Replace with function body.
