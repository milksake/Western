extends Node2D
class_name Rhythm

@export var bpm : float = 110
@export var off : float = 0.35
@export var window_ok : float = 0.12
@export var window_great : float = 0.06
@onready var beatDuration = 60.0 / bpm

signal beat

func _ready():
	assert(2 * window_ok < beatDuration)
	$Player.play()

var lastBeat = 0

var nextTargetTime = 0

var lastGetBeat = -1

var nextTargetTimeCnt = 0

func updateTargetTime():
	lastGetBeat = nextTargetTimeCnt
	nextTargetTime += beatDuration
	nextTargetTimeCnt += 1

func getTime():
	var time = $Player.get_playback_position() + AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	time += off
	return time

func getBeat():
	return lastGetBeat

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
	
