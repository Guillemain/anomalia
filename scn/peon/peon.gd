extends CharacterBody2D

signal dead

const explo := preload("res://scn/fx/exploenemy.tscn")

@export var use_stach := true

@export var dumb = false

@export var max_speed := 130.0
@export var min_speed := 80.0
var speed := 120.0

@export var smart := 0.1
@export var acc = 5.0
var target : CharacterBody2D


var is_dead := false
var moustach_inf := Vector2.ZERO
var where_to_tun
func _ready():
	speed = randf_range(min_speed, max_speed)
	if get_parent().has_node("Player"):
		target = get_parent().get_node("Player")
	if dumb: 
		$peorender.play("idle")
		$hurtBox.monitorable = false
	
	
func _physics_process(delta):
	if dumb :
		return
	if is_dead:
		return
	var lock := 0
	if use_stach:
		moustach_inf = Vector2.ZERO
		
		if $pivot/forward.is_colliding() :
			moustach_inf +=  global_position - $pivot/forward.get_collision_point() + $pivot/forward.get_collision_normal()
			lock += 1
		if $pivot/right.is_colliding() :
			moustach_inf +=  global_position - $pivot/right.get_collision_point() + $pivot/right.get_collision_normal()
			lock += 1
		if $pivot/left.is_colliding() :
			moustach_inf +=  global_position - $pivot/left.get_collision_point() + $pivot/left.get_collision_normal()
			lock += 1
		if moustach_inf.length_squared() < 0.01 :
			moustach_inf = Vector2.ZERO
		else: 
			moustach_inf = moustach_inf.normalized()
		
	if target != null :
		if lock < 3:
			where_to_tun = (target.position-position + target.velocity*smart).normalized()
			
			where_to_tun = (where_to_tun+moustach_inf*0.9).normalized()
			velocity = lerp(
				velocity,
			 	 where_to_tun * speed,
			 	delta * acc )
			$peorender.play("run")
			$peorender.orient(velocity)
			move_and_slide() 
		else:
			$peorender.play("idle")
		($pivot as Node2D).look_at(target.position)
	else :
		$peorender.play("idle")

func reste_colldier():
	($hurtBox as Area2D).monitorable = false
	($aberration_test as Area2D).monitorable = false
	($hurtBox as Area2D).monitoring = false
	($aberration_test as Area2D).monitoring = false
	dead.emit()
	
	
func exploddde():
	var inst := explo.instantiate()
	get_parent().add_child(inst)
	inst.position = position
	queue_free()

func _on_aberration_test_area_entered(area):
	if is_dead:
		return
	is_dead = true
	$peorender.play("hurted")
	$peorender.sanim_end.connect(exploddde)
	call_deferred("reste_colldier")

func attk():
	if is_dead:
		return
	is_dead = true
	$peorender.play("Attk",2.0)
	$peorender.sanim_end.connect(exploddde)
	call_deferred("reste_colldier")
	
