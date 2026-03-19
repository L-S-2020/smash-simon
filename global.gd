extends Node

var lobby_data # Format: { "players": [{ "device_id": 0, "character_index": 0, "character_name": "Moritz" }], "map_index": 1, "map_name": "Desert" }
var life = [0, 0, 0, 0]
var Runde: int = 1
var Rundenstand = [0, 0, 0, 0]

const character_names: PackedStringArray = ["Moritz", "Martin", "Leonard", "Johannes", "Jan", "Simon",]
const character_textures: Array[Texture2D] = [
	preload("res://chars/pp/moritz.png"),
	preload("res://chars/pp/martin.png"),
	preload("res://chars/pp/leonard.png"),
	preload("res://chars/pp/johannes.png"),
	preload("res://chars/pp/jan.png"),
	preload("res://chars/pp/simon.png"),]
	
const character_boxes = [
	preload("res://scenes/players/collision_shape_moritz.tscn"),
	preload("res://scenes/players/collision_shape_martin.tscn"),
	preload("res://scenes/players/collision_shape_leonard.tscn"),
	preload("res://scenes/players/collision_shape_johannes.tscn"),
	preload("res://scenes/players/collision_shape_jan.tscn"),
	preload("res://scenes/players/collision_shape_simon.tscn"),
]

const character_anims = [
	preload("res://chars/anims/tres/moritz.tres"),
	preload("res://chars/anims/tres/martin.tres"),
	preload("res://chars/anims/tres/leonard.tres"),
	preload("res://chars/anims/tres/johannes.tres"),
	preload("res://chars/anims/tres/jan.tres"),
	preload("res://chars/anims/tres/simon.tres"),
]

const lifebar_bgs = [
	preload("res://chars/lifebars/bg/moritz.png"),
	preload("res://chars/lifebars/bg/martin.png"),
	preload("res://chars/lifebars/bg/leonard.png"),
	preload("res://chars/lifebars/bg/johannes.png"),
	preload("res://chars/lifebars/bg/jan.png"),
	preload("res://chars/lifebars/bg/simon.png"),
]

const lifebar_fills = [
	preload("res://chars/lifebars/fill/moritz.png"),
	preload("res://chars/lifebars/fill/martin.png"),
	preload("res://chars/lifebars/fill/leonard.png"),
	preload("res://chars/lifebars/fill/johannes.png"),
	preload("res://chars/lifebars/fill/jan.png"),
	preload("res://chars/lifebars/fill/simon.png"),
]

const map_names: PackedStringArray = ["GSG", "5",]
const map_textures: Array[Texture2D] = [
	preload("res://maps/bg/classroom.png"),
	preload("res://maps/bg/5.png")
]
const map_scenes: PackedStringArray = ["res://maps/gsg.tscn", "res://maps/5.tscn"]

const ALL_STATS = [{
	"leben": 100,
	"damage_schlagen": 10,
	"damage_treten": 20,
	"schlagen_timeout": 0.5,
	"speed": 300.0, }, {
	"leben": 100,
	"damage_schlagen": 10,
	"damage_treten": 20,
	"schlagen_timeout": 0.5,
	"speed": 300.0, }, {
	"leben": 100,
	"damage_schlagen": 10,
	"damage_treten": 20,
	"schlagen_timeout": 0.5,
	"speed": 300.0, }, {
	"leben": 100,
	"damage_schlagen": 10,
	"damage_treten": 20,
	"schlagen_timeout": 0.5,
	"speed": 300.0, }, {
	"leben": 100,
	"damage_schlagen": 10,
	"damage_treten": 20,
	"schlagen_timeout": 0.5,
	"speed": 300.0, }, {
	"leben": 100,
	"damage_schlagen": 10,
	"damage_treten": 20,
	"schlagen_timeout": 0.5,
	"speed": 300.0, },
]
