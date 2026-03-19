extends Control

signal selection_finished(picks: Array)

enum Mode { CHARACTER_SELECT, MAP_SELECT }
var mode: int = Mode.CHARACTER_SELECT

const MAX_PLAYERS := 4

@export var character_names: PackedStringArray = Global.character_names
@export var character_textures: Array[Texture2D] = Global.character_textures

@export var map_names: PackedStringArray = Global.map_names
@export var map_textures: Array[Texture2D] = Global.map_textures # optional preview textures

var map_idx: int = 0

# Pro Slot: { device, char_idx, ready }
var slots: Array = []

# Pro Slot UI: { spieler:Label, bereit:Label, bild:TextureRect, left:Label, right:Label }
var ui: Array = []

@onready var map_popup: Control = $MapPopup
@onready var map_name_label: Label = $MapPopup/Panel/MapName
@onready var map_preview: TextureRect = $MapPopup/Panel/Preview
@onready var map_hint: Label = $MapPopup/Panel/Hint

func _ready() -> void:
	for _i in range(MAX_PLAYERS):
		slots.append({ "device": null, "char_idx": 0, "ready": false })

	ui = [
		_pack_ui($"P1"),
		_pack_ui($"P2"),
		_pack_ui($"P3"),
		_pack_ui($"P4"),
	]

	# Optional: wenn Controller abgezogen wird, Slot freigeben
	Input.joy_connection_changed.connect(_on_joy_connection_changed) # device, connected [page:9]

	map_popup.visible = false
	_refresh_ui()
	_refresh_map_popup()

func _pack_ui(root: Node) -> Dictionary:
	return {
		"spieler": root.get_node("spieler") as Label,
		"bereit": root.get_node("bereit") as Label,
		"bild": root.get_node("bild") as TextureRect,
		"left": root.get_node("left") as Label,
		"right": root.get_node("right") as Label,
	}

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventJoypadButton):
		return
	if not event.pressed:
		return

	var d := event.device
	var btn = event.button_index

	# ---------------- MAP SELECT MODE (nur P1 darf) ----------------
	if mode == Mode.MAP_SELECT:
		var p1_device = slots[0].device
		if p1_device == null or d != p1_device:
			return

		if btn == JOY_BUTTON_DPAD_LEFT:
			_map_prev()
			return
		if btn == JOY_BUTTON_DPAD_RIGHT:
			_map_next()
			return

		if btn == JOY_BUTTON_A:
			_start_game()
			return

		if btn == JOY_BUTTON_B:
			_close_map_select()
			return

		return

	# ---------------- CHARACTER SELECT MODE ----------------
	# A: Join (wenn neu) oder Confirm (wenn bereits gejoint)
	if btn == JOY_BUTTON_A:
		var idx := _slot_by_device(d)
		if idx == -1:
			idx = _first_free_slot()
			if idx == -1:
				return # schon 4 belegt
			slots[idx].device = d
			slots[idx].char_idx = 0
			slots[idx].ready = false
		else:
			slots[idx].ready = true

		_refresh_ui()
		_try_open_map_select_if_ready()
		return

	# B: Unready oder Leave
	if btn == JOY_BUTTON_B:
		var idxb := _slot_by_device(d)
		if idxb == -1:
			return

		if slots[idxb].ready:
			slots[idxb].ready = false
		else:
			slots[idxb].device = null
			slots[idxb].ready = false
			slots[idxb].char_idx = 0

		_refresh_ui()
		return

	# D-Pad: nur wenn gejoint und NICHT ready
	var sidx := _slot_by_device(d)
	if sidx == -1 or slots[sidx].ready:
		return

	if btn == JOY_BUTTON_DPAD_LEFT:
		slots[sidx].char_idx = (slots[sidx].char_idx - 1 + character_names.size()) % character_names.size()
		_refresh_ui()
	elif btn == JOY_BUTTON_DPAD_RIGHT:
		slots[sidx].char_idx = (slots[sidx].char_idx + 1) % character_names.size()
		_refresh_ui()

func _slot_by_device(d: int) -> int:
	for i in range(MAX_PLAYERS):
		if slots[i].device == d:
			return i
	return -1

func _first_free_slot() -> int:
	for i in range(MAX_PLAYERS):
		if slots[i].device == null:
			return i
	return -1

func _on_joy_connection_changed(device: int, connected: bool) -> void:
	if connected:
		return
	for s in slots:
		if s.device == device:
			s.device = null
			s.ready = false
			s.char_idx = 0
	_refresh_ui()

func _refresh_ui() -> void:
	for i in range(MAX_PLAYERS):
		var s: Dictionary = slots[i]
		var u: Dictionary = ui[i]

		var joined := (s.device != null)
		var ready = joined and s.ready

		u.left.visible = joined and (not ready)
		u.right.visible = joined and (not ready)

		u.bild.visible = joined
		if joined:
			var idx := int(s.char_idx)
			var cname := character_names[idx] if idx >= 0 and idx < character_names.size() else "?"
			var joyname := Input.get_joy_name(s.device)

			u.spieler.text = cname
			u.bereit.text = "Bereit!" if ready else ""

			if idx >= 0 and idx < character_textures.size() and character_textures[idx] != null:
				u.bild.texture = character_textures[idx]
			else:
				u.bild.texture = null
		else:
			u.spieler.text = "3 = Join"
			u.bereit.text = ""
			u.bild.texture = null

func _all_joined_ready() -> bool:
	var joined := 0
	var ready := 0
	for s in slots:
		if s.device != null:
			joined += 1
			if s.ready:
				ready += 1
	return joined >= 1 and ready == joined

func _try_open_map_select_if_ready() -> void:
	# Wichtig: P1 muss existieren, weil nur P1 die Map wählen darf
	if slots[0].device == null:
		return
	if not _all_joined_ready():
		return
	_open_map_select()

func _open_map_select() -> void:
	mode = Mode.MAP_SELECT
	map_popup.visible = true
	_refresh_map_popup()

func _close_map_select() -> void:
	mode = Mode.CHARACTER_SELECT
	map_popup.visible = false
	_refresh_ui()

func _map_prev() -> void:
	if map_names.is_empty():
		return
	map_idx = (map_idx - 1 + map_names.size()) % map_names.size()
	_refresh_map_popup()

func _map_next() -> void:
	if map_names.is_empty():
		return
	map_idx = (map_idx + 1) % map_names.size()
	_refresh_map_popup()

func _refresh_map_popup() -> void:
	if map_names.is_empty():
		map_name_label.text = "Keine Maps konfiguriert"
		map_hint.text = "2 = Zurück"
		map_preview.texture = null
		return

	map_name_label.text = "Map: %s" % map_names[map_idx]
	map_hint.text = "3 = Start | 2 = Zurück"

	if map_idx >= 0 and map_idx < map_textures.size() and map_textures[map_idx] != null:
		map_preview.texture = map_textures[map_idx]
	else:
		map_preview.texture = null

func _start_game() -> void:
	var picks: Array = []
	for s in slots:
		if s.device != null:
			picks.append({
				"device_id": s.device,
				"character_index": s.char_idx,
				"character_name": character_names[int(s.char_idx)],
			})

	var result := {
		"players": picks,
		"map_index": map_idx,
		"map_name": map_names[map_idx] if map_idx >= 0 and map_idx < map_names.size() else "",
	}
	#result["players"].append({ "device_id": -1, "character_index": 0, "character_name": "Moritz" })
	Global.lobby_data = result
	print(result)
	get_tree().change_scene_to_file("res://scenes/main.tscn")
