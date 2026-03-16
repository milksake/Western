extends Node2D

@onready var reload: Node2D = $Reload
@onready var aim: Area2D = $Aim
@onready var rhythm : Rhythm = $Rhythm
const STAR = preload("uid://b35j4t3r82npu")
@onready var health_bar: HBoxContainer = $CanvasLayer/HealthBar

@export var enemies: Array[Area2D]
@export var next_scene: PackedScene

var health : int = 5

var sprite1 = preload("res://Sprites/Enemy/Enemy.png")
var sprite2 = preload("res://Sprites/Enemy/Enemy2.png")
var sprite3 = preload("res://Sprites/Enemy/Enemy3.png")

func _ready() -> void:
	$Label2.visible = false
	for enemy in enemies:
		enemy.shots_player.connect(damage_player)
		if name == "FirstLevel":
			enemy.sprite_2d.texture = sprite1
			enemy.health = 1
		elif name == "SecondLevel":
			enemy.sprite_2d.texture = sprite2
			enemy.health = 2
		else:
			enemy.sprite_2d.texture = sprite3
			enemy.health = 3
	for i in range(health):
		var tex := TextureRect.new()
		tex.texture = STAR
		health_bar.add_child(tex)

func damage_player():
	
	if health <= 0:
		return
	health -= 1
	update_health()
	shake_camera()
	
func update_health():
	for child in health_bar.get_children():
		child.queue_free()

	for i in range(health):
		var tex := TextureRect.new()
		tex.texture = STAR
		health_bar.add_child(tex)

func _process(delta: float) -> void:
	enemies = enemies.filter(func(e): return is_instance_valid(e))
	$Label.text = "Enemies left: " + str(enemies.size())
	if enemies.is_empty():
		$Label2.visible = true
		get_tree().paused = true
		await get_tree().create_timer(0.7, true).timeout
		get_tree().paused = false
		get_tree().change_scene_to_packed(next_scene)
		
	if health <= 0:
		$Label2.visible = true
		get_tree().paused = true
		await get_tree().create_timer(0.7, true).timeout
		get_tree().paused = false
		get_tree().reload_current_scene()
	pass

func shake_camera():
	var tween = create_tween()
	tween.tween_property($Camera2D, "offset", Vector2(randf_range(-10,10), randf_range(-10,10)), 0.05)
	tween.tween_property($Camera2D, "offset", Vector2.ZERO, 0.05)

func _on_reload_left_action(state: int) -> void:
	var x = rhythm.tryBeat()
	if x > 0:
		if state > -1:
			print("Great" if x == 2 else "Ok")
			reload.dispose(state)
			$Aim/GPUParticles2D.restart()
			$Aim/SoundShoot.play(0)
			var overlapping_areas = aim.get_overlapping_areas()
			if overlapping_areas and overlapping_areas[0].has_method("take_damage"):
				overlapping_areas[0].take_damage(rhythm.getBeat())
		else:
			print("No bullet")
	else:
		print("Out of Beat")

func _on_reload_right_action(state: int) -> void:
	var x = rhythm.tryBeat()
	if x > 0:
		if state < 0:
			print("Great" if x == 2 else "Ok")
			reload.reload(state)
		else:
			print("Bullet Already")
	else:
		print("Out of Beat")

func _on_enemy_is_shot(points: Variant) -> void:
	enemies = enemies.filter(func(e): return is_instance_valid(e))

	if enemies.is_empty():
		print("ganaste")

func _on_rhythm_beat() -> void:
	reload.beat_sprite()
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.beat()
