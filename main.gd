extends Node2D

var running = false
var player_objects = []
var map_object
@onready var Spawns = [$"Spawns/1", $"Spawns/2", $"Spawns/3", $"Spawns/4"]
@onready var Lifebars = [$"Camera2D/UI/1", $"Camera2D/UI/2", $"Camera2D/UI/3", $"Camera2D/UI/4"]

func start_game():
	var number = 0
	for p in player_objects:
		p.global_position = Spawns[number].global_position
		Global.life[number] = 100
		number += 1
		p.start_game()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Lade map
	var map_index = Global.lobby_data["map_index"]
	var ps: PackedScene = load(Global.map_scenes[map_index])
	var inst := ps.instantiate()
	get_tree().current_scene.add_child(inst)
	map_object = inst
	# Lade Spieler
	var number = 0
	for p in Global.lobby_data["players"]:
		var playeR_inst: PackedScene = load("res://scenes/player.tscn")
		var p_inst := playeR_inst.instantiate()
		get_tree().current_scene.add_child(p_inst)
		p_inst.setup(p)
		player_objects.append(p_inst)
		$MainCamera.append_follow_targets(p_inst)
		p_inst.find_child("Health").died.connect(_on_player_died)
		Lifebars[number].find_child("Lifebar").texture = Global.lifebar_bgs[p["character_index"]]
		Lifebars[number].find_child("fill").texture_progress = Global.lifebar_fills[p["character_index"]]
		Lifebars[number].visible = true
		number += 1
	start_game()
	Global.Runde = 1
	Global.Rundenstand = [0, 0, 0, 0]
	
func _on_player_died(entity):
	print("Tod")
	var anzLebend = 0
	for i in Global.life:
		if i > 0:
			anzLebend += 1
	if anzLebend < 2:
		Rundefertig()

func Rundefertig():
	print("Runde fertig")
	var pos = 0
	for i in Global.life:
		if i > 0:
			Global.Rundenstand[pos] += 1
		pos += 1
	
	Global.Runde += 1
	$nextround.start(2.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var number = 0
	for l in Global.life:
		Lifebars[number].find_child("fill").value = (l*0.41) + 42
		number += 1


func _on_nextround_timeout() -> void:
	if Global.Runde == 4:
		get_tree().change_scene_to_file("res://scenes/winner.tscn")
	else:
		start_game()
