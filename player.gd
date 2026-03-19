extends CharacterBody2D

# Settings von Spawner
var type = "" # Name der Person (z.B. Simon), Note: alle Namen normal geschrieben!
var device_number = 0 # Nummer des Spielers (bei lokalen Multiplayer), wichtig für Input 
#Achtung: -1 = Tastatur, 0 = Controller 0, 1 = Controller 1, etc. !!!!!!!!
var input: DeviceInput = DeviceInput.new(-1)
var SPEED = 300.0
const JUMP_VELOCITY = -600
var stats
var number = 0
var aktuelle_richtung = "rechts"
@export var running: bool  = false # Spiel läuft grad
const schlag_box = preload("res://scenes/Hitbox_schlagen.tscn")
var player_nr


func _init() -> void:
	#input = DeviceInput.new(-1)
	pass

func start_game():
	$Health.current = stats["leben"]
	running = true
	visible = true
	position.y = 0

func setup(player) -> void:
	type = player["character_name"]
	number = player["character_index"]
	device_number = player["device_id"]
	input = DeviceInput.new(device_number)
	stats = Global.ALL_STATS[player["character_index"]]
	SPEED = stats["speed"]
	$Health.max = stats["leben"]
	var hitbox = Global.character_boxes[number].instantiate()
	add_child(hitbox)
	var hurtbox = Global.character_boxes[number].instantiate()
	$HurtBox2D.add_child(hurtbox)
	$Sprite2D.sprite_frames = Global.character_anims[number]
	player_nr = Global.lobby_data["players"].find(player)
	
	
func _on_health_ready() -> void:
	pass

var kann_schlagen = true
var kann_blocken = true

func _physics_process(delta: float) -> void:
	if not running:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if input.is_action_just_pressed("springen") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = input.get_axis("links", "rechts")
	if direction:
		if is_on_floor():
			$Sprite2D.play("laufen")
		velocity.x = direction * SPEED
		if direction > 0:
			aktuelle_richtung = "rechts"
		if direction < 0:
			aktuelle_richtung = "links"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not $Sprite2D.is_playing() or $Sprite2D.animation == "laufen":
			if is_on_floor():
				$Sprite2D.play("default")
	
	if input.is_action_just_pressed("springen") and is_on_floor():
		$Sprite2D.play("sprung")
		$audio.stream = load("res://audio/jump.wav")
		$audio.play()

	move_and_slide()
	
	# Blickrichtung ändern, Achtung: Collisionshapes mitändern
	if aktuelle_richtung == "rechts":
		$Sprite2D.flip_h = false
	if aktuelle_richtung == "links":
		$Sprite2D.flip_h = true

	# abilities
	if input.is_action_just_pressed("schlagen") and kann_schlagen:
		kann_schlagen = false
		#$schlagen_timeout.start(stats.schlagen_timeout)
		$schlagen_timeout.start(1)
		var schlag_inst = schlag_box.instantiate()
		add_child(schlag_inst)
		schlag_inst.get_child(0).amount = stats["damage_schlagen"]
		if aktuelle_richtung == "rechts":
			schlag_inst.transform = $HitBox_pos_right.transform
		if aktuelle_richtung == "links":
			schlag_inst.transform = $HitBox_pos_left.transform
		# schlagen animation
		$Sprite2D.play("schlagen")
		$audio.stream = load("res://audio/schlag.wav")
		$audio.play()
		
	if input.is_action_just_pressed("treten"): #Für Update!!!
		# treten
		pass
	
	if input.is_action_just_pressed("fähigkeit"): #Für Update!!!
		# fähigkeit
		pass

	if input.is_action_just_pressed("block") and kann_blocken:
		# block
		$HurtBox2D/CollisionShape2D.disabled = true
		$block_timeout.start(0.25) #Blocklänge festlegen!!!
		kann_blocken = false
		$block_time.start(2)
		$Sprite2D.play("block")

func _on_schlagen_timeout_timeout() -> void:
	kann_schlagen = true

#Sterben
func _on_health_died(entity: Node) -> void:
	if entity == self:
		visible = false
		running = false
		position.y = -1000
		Global.life[player_nr] = 0
		$audio.stream = load("res://audio/dead.wav")
		$audio.play()
		

func _on_health_revived(entity: Node) -> void:
	if entity == self:
		visible = true
		running = true
		position.y = 0

func _on_block_timeout_timeout() -> void:
	$HurtBox2D/CollisionShape2D.disabled = false

func _on_health_damaged(entity: Node, type: HealthActionType.Enum, amount: int, incrementer: int, multiplier: float, applied: int) -> void:
	if entity == self:
		Global.life[player_nr] = $Health.current
		$Sprite2D.play("fall")


func _on_block_time_timeout() -> void:
	kann_blocken = true
