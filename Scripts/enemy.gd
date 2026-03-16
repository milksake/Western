extends Area2D

var is_aimed : bool = false
var points : int = 100
@export var health : int = 1
signal is_shot(points)
signal shots_player()

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var attack_on_beat : int = 3
@export var delay_spawn_beats : int = 20
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var consecutive : Array[int]

var current_beat : int = 1
var spawn_counter := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	if parent:
		is_shot.connect(parent._on_enemy_is_shot)
	$Light.visible = false
	visible = false
var has_spawned = false


func beat():

	if not has_spawned:
		spawn_counter += 1

		if spawn_counter >= delay_spawn_beats:
			has_spawned = true
			visible = true

		return


	$Label.text = str(attack_on_beat - current_beat)

	if attack_on_beat - current_beat == 2:
		$Exclamation.visible = true


	if current_beat == attack_on_beat:
		attack()
		$Exclamation.visible = false


	current_beat += 1

	if current_beat > attack_on_beat:
		current_beat = 1
	
	
func attack():
	shots_player.emit()
	animation_player.play("shoot_position")
	$AudioStreamPlayer.play(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func take_damage(beatt : int):
	if is_aimed:
		if not (consecutive.is_empty() or consecutive[-1] == beatt-1):
			consecutive.clear()
		consecutive.push_back(beatt)
		sprite_2d.modulate = Color(4, 4, 4, 1.0)

		await get_tree().create_timer(0.3).timeout

		sprite_2d.modulate = Color.WHITE
		
		current_beat = 1
		$Label.text = str(attack_on_beat - current_beat)
		
		if check_if_dead():
			is_shot.emit(points)
			queue_free()
			

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_aimed = true
	pass # Replace with function body.

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_aimed = false
	pass # Replace with function body.

func check_if_dead() -> bool:
	print(consecutive, health)
	if len(consecutive) >= health:
		return true
	return false
