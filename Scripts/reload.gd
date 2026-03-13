extends Node2D

@onready var barrel = $Barrel
@export var bullets : int = 6
@export var time : float = 0.05

@onready var space : float = 360.0 / bullets
var pos = 0

var can_move : bool = true
var buff : int = 0
var buff_right : bool = false
var buff_middle : bool = false
var buff_left : bool = false

signal left_action(state : int)
signal middle_action(state : int)
signal right_action(state : int)

var state : Array[int]

func update():
	for i in range(bullets):
		if (state[i] == 0):
			barrel.get_child(i).visible = false
		else:
			barrel.get_child(i).visible = true

func dispose(bullet):
	if bullet < 0:
		return
	state[bullet] = 0
	update()

func reload(bullet):
	if bullet >= 0:
		return
	state[-bullet-1] = 1
	update()

func _ready() -> void:
	state.resize(bullets)
	var dir : Vector2 = Vector2.UP
	for i in range(bullets):
		var b = Sprite2D.new()
		b.texture = load("res://icon.svg")
		b.position = dir * 50
		b.scale = Vector2(0.25, 0.25)
		b.visible = false
		barrel.add_child(b)
		
		dir = dir.rotated(-deg_to_rad(space))

func move(dir : int):
	var t = create_tween()
	t.tween_property(barrel, "rotation_degrees", barrel.rotation_degrees + space * dir, time)
	can_move = false
	t.connect("finished", reactivate)
	
	pos += dir
	pos += bullets
	pos %= bullets

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("roll_up"):
		if can_move:
			move(-1)
		else:
			buff -= 1
	if Input.is_action_just_pressed("roll_down"):
		if can_move:
			move(+1)
		else:
			buff += 1
	if Input.is_action_just_pressed("click"):
		if can_move:
			emit_signal("left_action", -pos-1 if state[pos] == 0 else pos)
		else:
			buff_left = true
	if Input.is_action_just_pressed("middleclick"):
		if can_move:
			emit_signal("middle_action", -pos-1 if state[pos] == 0 else pos)
		else:
			buff_middle = true
	if Input.is_action_just_pressed("anticlick"):
		if can_move:
			emit_signal("right_action", -pos-1 if state[pos] == 0 else pos)
		else:
			buff_right = true

func reactivate():
	if buff > 0:
		buff -= 1
		move(+1)
	elif buff < 0:
		buff += 1
		move(-1)
	else:
		can_move = true
		if buff_left:
			emit_signal("left_action", -pos-1 if state[pos] == 0 else pos)
			buff_left = false
		if buff_right:
			emit_signal("right_action", -pos-1 if state[pos] == 0 else pos)
			buff_right = false
		if buff_middle:
			emit_signal("middle_action", -pos-1 if state[pos] == 0 else pos)
			buff_middle = false

func _on_left_action(state : int) -> void:
	pass
	#print("left", state)

func _on_middle_action(state : int) -> void:
	pass
	#dispose(state)
	#print("middle", state)

func _on_right_action(state : int) -> void:
	pass
	#reload(state)
	#print("right", state)
