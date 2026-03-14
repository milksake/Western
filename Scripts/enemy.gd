extends Area2D

var is_aimed : bool = false
var points : int = 100
var health : int = 10
signal is_shot(points)
signal shots_player()

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shoot: TextureRect = $Shoot
@export var attack_on_beat : int = 3
var current_beat : int = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	if parent:
		is_shot.connect(parent._on_enemy_is_shot)

func beat():
	$Label.text = str(current_beat)
	if current_beat == attack_on_beat:
		attack()
	current_beat += 1
	if current_beat > attack_on_beat:
		current_beat = 1
	
	
func attack():
	shots_player.emit()
	$AudioStreamPlayer.play(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func take_damage(damage: int):
	if is_aimed:
		health -= damage
		sprite_2d.modulate = Color(4, 4, 4, 1.0)

		await get_tree().create_timer(0.3).timeout

		sprite_2d.modulate = Color.WHITE
		
		current_beat = 1
		$Label.text = str(current_beat)
		
		if check_if_dead():
			is_shot.emit(points)
			self.modulate = Color.TRANSPARENT

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
