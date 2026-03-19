class_name BasicHitbox extends Node2D

@onready var hit_box: HitBox2D = $HitBox_schlagen


func _ready() -> void:
	hit_box.action_applied.connect(_on_action_applied)
	$Timer.timeout.connect(_on_timer)
	$Timer.start(0.1)
	hit_box.ignore_collisions = false
	print("added......")


func _on_action_applied(_hurt_box: HurtBox2D) -> void:
	hit_box.ignore_collisions = true
	queue_free()
	print("action applied")

func _on_timer():
	hit_box.ignore_collisions = true
	queue_free()
	print("timer um")
