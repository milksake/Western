extends Node2D
class_name Rhythm

@export var bpm : float = 110
@export var off : float = 0.32
@export var window_ok : float = 0.1
@export var window_great : float = 0.045
@onready var beatDuration = 60.0 / bpm

signal beat

func _ready():
	assert(2 * window_ok < beatDuration)
	$Player.play()

var lastBeat = 0

var nextTargetTime = 0

func updateTargetTime():
	nextTargetTime += beatDuration

func getTime():
	var time = $Player.get_playback_position() + AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	time += off
	return time

func _process(_delta):
	var time = getTime()
	var currBeat : int = (time) / beatDuration
	
	if lastBeat < currBeat:
		emit_signal("beat")
		lastBeat = currBeat
		$AudioStreamPlayer.play(0)
	
	if time > nextTargetTime + window_ok:
		updateTargetTime()

func tryBeat():
	var time = getTime()
	
	var d = time - nextTargetTime
	#print(d)
	d = abs(d)
	if d <= window_great:
		updateTargetTime()
		return 2
	if d <= window_ok:
		updateTargetTime()
		return 1
	return 0
	
