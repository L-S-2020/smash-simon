extends Node2D

var winner
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	winner = Global.Rundenstand.find(Global.Rundenstand.max())
	$Leonard.texture = Global.character_textures[winner]
	$Name.text = "Gewinner: " + Global.character_names[winner]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
