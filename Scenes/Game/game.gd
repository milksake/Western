extends Node2D

var current_slot = 0
var slots = [0,0,0,0,0,0]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("roll_up"):
		current_slot = (current_slot - 1 + slots.size()) % slots.size()
		print(current_slot)
		pass
	if Input.is_action_just_pressed("roll_down"):
		current_slot = (current_slot + 1) % slots.size()
		print(current_slot)
		pass
	if Input.is_action_just_pressed("click"):
		print("Shoot")
		pass
	if Input.is_action_just_pressed("anticlick"):
		print("Hide")
		pass
	if Input.is_action_just_pressed("middleclick"):
		print("Reload")
		pass
	pass
