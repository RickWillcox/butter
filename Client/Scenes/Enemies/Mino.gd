extends KinematicBody2D

enum{
	IDLE, WANDER, CHASE, ATTACK, DEAD
}

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = $AnimationTree.get("parameters/playback")
onready var attack_cooldown_timer = $AttackCooldown

var velocity = Vector2.ZERO
var blend_position = Vector2.ZERO
var facing_blend_position = Vector2.ZERO
var rng
var state = IDLE
var attacking = false
var current_position
var old_position = Vector2(0,0)
var attack_type = ""
var max_hp	= 9000
var current_hp = 9000
var type
var dead = false
var update_position = Vector2(0,0)

func ready():
	$HealthBar.max_value = max_hp
	$HealthBar.value = current_hp

func _physics_process(delta):
	if current_hp <= 0:
		queue_free()
	animation_tree.active = true
	blend_position()
	match state:
		IDLE:
			animation_state.travel("Idle")
		WANDER:
			animation_state.travel("Run")
		CHASE:
			animation_state.travel("Run")
		ATTACK:
			if attacking == false:
				attacking = true
				if attack_type == "AttackSwing":
					attack_cooldown_timer.wait_time = 2
				if attack_type == "AttackSpin":
					attack_cooldown_timer.wait_time = 1.4
				attack_cooldown_timer.start()
				animation_state.travel(attack_type)
		DEAD:
			queue_free()
	
func MoveEnemy(new_position, server_state, server_attack_type):
	state = server_state
	if not server_attack_type == "Not Attacking":
		attack_type = server_attack_type
		state = ATTACK
		return
	if old_position.x > new_position.x:
		facing_blend_position = Vector2(-2,0)
		set_position(new_position)
		state = WANDER
	elif old_position.x < new_position.x:
		facing_blend_position = Vector2(2,0)
		set_position(new_position)
		state = WANDER
	else:
		state = IDLE
	old_position = new_position
	
func Health(health):
	if health != current_hp:
		if dead == false:
			#hit animation
			pass
		current_hp = health
		HealthBarUpdate()
		if current_hp <= 0 and dead == false:
			dead = true
			OnDeath()
			
func HealthBarUpdate(): #15 25min
	$HealthBar.value = current_hp
	
func OnDeath():
	queue_free()
	
func blend_position():
	animation_tree.set("parameters/Idle/blend_position", facing_blend_position)
	animation_tree.set("parameters/Run/blend_position", facing_blend_position)
	animation_tree.set("parameters/AttackSwing/blend_position", facing_blend_position)
	animation_tree.set("parameters/AttackSpin/blend_position", facing_blend_position)


func _on_AttackCooldown_timeout() -> void:
	state = IDLE

