extends KinematicBody2D

enum{
	IDLE, WANDER, CHASE, ATTACK, DEAD
}

enum{
	LEFT, RIGHT
}

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = $AnimationTree.get("parameters/playback")

var velocity = Vector2.ZERO
var blend_position = Vector2.ZERO
var facing_blend_position = Vector2.ZERO
var rng
var state = IDLE
var facing = RIGHT
var attacking = false
var current_position
var old_position = Vector2(0,0)

var max_hp	= 9000
var current_hp = 9000
var type
var dead = false

func ready():
	$HealthBar.max_value = max_hp
	$HealthBar.value = current_hp

func _physics_process(delta):
	blend_position()
	match state:
		IDLE:
			print("idle")
		WANDER:
			print("wander")
		CHASE:
			print("chase")
		ATTACK:
			print("attack")
		DEAD:
			queue_free()

func MoveEnemy(new_position):
	var facing = ""
	set_position(new_position)
	if old_position.x > new_position.x:
		facing_blend_position = Vector2(-2,0)
		facing = "Left"
	elif old_position.x < new_position.x:
		facing_blend_position = Vector2(2,0)
		facing = "Right"
	else:
		pass
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
	$HealthBar.visible = false
	$AnimationPlayer.stop()
	yield(get_tree().create_timer(0.4), "timeout")
	queue_free()
	
func blend_position():
	animation_tree.set("parameters/Idle/blend_position", facing_blend_position)
	animation_tree.set("parameters/Run/blend_position", facing_blend_position)
	animation_tree.set("parameters/AttackSwing/blend_position", facing_blend_position)
	animation_tree.set("parameters/AttackSpin/blend_position", facing_blend_position)
