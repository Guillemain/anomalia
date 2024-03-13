extends CharacterBody2D


signal move
signal pv_lost
signal dead
signal pv_get
signal spv_change(new_pv:int)
signal sbonus
signal start_loop
signal loop_complete
signal dasheeer
enum EState {MOVE,TRACE,RECUP}

var PV := 5
const dash_fx := preload("res://scn/fx/dash_fx.tscn")
const end_loop_fx := preload("res://scn/fx/end_llop.tscn")
@export var SPEED := 300.0
@export var TRACE_SPEED := 600.0
@export var JUMP_VELOCITY := -400.0

const DASH_SPEED := 1000.0
const dash_time := 0.05

const acc_move := 0.4
const acc_trace := 0.1
const acc_dashing := 0.001
var acc = 0.4

var sate = EState.MOVE

var current_speed := SPEED
var direction = Vector2.ZERO

var can_stop = true
var can_shoot = true
var dashing = false

var is_dead := false

var frame_no_move = 5
var current_frame_nomove = -1 

func _ready():
	spv_change.emit(PV)

func _physics_process(delta):
	$Label.text = EState.find_key(sate)
	$av.visible = sate == EState.TRACE
	if is_dead:
		return
	if Input.is_action_just_pressed("action1") and can_shoot and (sate != EState.RECUP):
		if(sate == EState.TRACE) and has_node("../LoopCreator"):
			get_node("../LoopCreator").reset_loop()
			start_cooldown()
		else:
			if has_node("../LoopCreator"):
				get_node("../LoopCreator").start_loop(self)
			start_loop.emit()
			current_speed = TRACE_SPEED*0.7
			var tween := get_tree().create_tween()
			tween.tween_property(self,"current_speed",TRACE_SPEED,0.1).set_trans(Tween.TRANS_EXPO)
			can_stop = false
			$GeoInSprite.play("actionA")
			sate = EState.TRACE
			acc = acc_trace
		
	var new_dir = Vector2.ZERO
	
	if Input.is_action_pressed("left"):
		new_dir += Vector2.LEFT
	if Input.is_action_pressed("right"):
		new_dir += Vector2.RIGHT
	if Input.is_action_pressed("up"):
		new_dir += Vector2.UP
	if Input.is_action_pressed("down"):
		new_dir += Vector2.DOWN
	if not can_stop and (new_dir.length_squared() < 0.1): 
		new_dir = direction
	direction = lerp(direction,new_dir,acc)
	if new_dir != Vector2.ZERO:
		move.emit()
		velocity = direction.normalized() * current_speed
		$GeoInSprite.orient(direction.normalized())
		if sate == EState.MOVE:
			$GeoInSprite.play("run")
	else:
		velocity = Vector2.ZERO
		
		if sate == EState.MOVE:
			$GeoInSprite.play("idle")
	$pivot.look_at(global_position + direction.normalized()*200)
	move_and_slide()
func do_trace():
	pass

func end_loop():
	var inst := end_loop_fx.instantiate()
	get_parent().add_child(inst)
	inst.position = position

func _on_loop_area_entered(area):
	start_cooldown()
	var id = area.id
	if has_node("../LoopCreator"):
		get_node("../LoopCreator").end_loop(id)
		loop_complete.emit()
		end_loop()
	else :
		end_loop()

func start_cooldown(clinote=false):
	#clig
	sate = EState.RECUP
	$GeoInSprite.play("recup")
	dashing = false
	can_stop = true
	current_speed = SPEED
	acc = acc_move
	get_tree().create_timer(0.05).timeout.connect(end_cooldown)

func start_dash():
	dashing = true
	can_stop = false
	can_shoot = false
	start_cooldown()
	current_speed = DASH_SPEED
	acc = acc_dashing
	await get_tree().create_timer(dash_time).timeout
	dashing = false
	can_stop = true
	current_speed = SPEED
	acc = acc_move

func end_cooldown():
	can_shoot = true
	sate = EState.MOVE



func _on_bonu_loop_area_entered(area):
	get_node("../LoopCreator").max_length+=10
	sbonus.emit()
	#change_pv(PV+1)
	area.queue_free()
	pass

func _on_hitbox_area_entered(area):
	get_node("../LoopCreator").reset_loop()
	if sate != EState.RECUP :
		start_cooldown()
		change_pv(PV-1)
		area.get_parent().attk()
		$GeoInSprite.call_deferred("make_blink")
	if sate == EState.TRACE:
		#get_node("../LoopCreator").reset_loop()
		end_loop()
	
	
func change_pv(new_pv : int):
	if new_pv < PV:
		pv_lost.emit()
	else:
		pv_get.emit()
	PV = min(5,new_pv)
	spv_change.emit(PV)
	if PV <= 0:
		is_dead = true
		dead.emit()

func _on_aberration_test_area_entered(area):
	#if has_node("../LoopCreator"):
		#get_node("../LoopCreator").reset_loop()
	if sate == EState.RECUP:
		return
	var old_pos = global_position
	global_position =  $pivot/Dasher.get_safe_area()
	dasheeer.emit()
	var instance := dash_fx.instantiate()
	get_parent().add_child(instance)
	instance.set_point_position(0,old_pos)
	instance.set_point_position(1,global_position)
	#if sate == EState.RECUP:
		#return
	#collision_mask = 0x0000
	#collision_layer = 0x0000
	#dashing = true
	#can_stop = false
	#can_shoot = false
	#current_speed = DASH_SPEED * 1.5
	#acc = acc_dashing
	#
func _on_aberration_test_area_exited(area):
	return
	collision_mask = 0x0001
	collision_layer = 0x0001
	dashing = false
	if sate != EState.TRACE:
		can_stop = true
		var tween := get_tree().create_tween()
		tween.tween_property(self,"current_speed",SPEED,0.1).set_trans(Tween.TRANS_CUBIC)
		acc = acc_move
		start_cooldown()
	else:
		acc = acc_trace
		current_speed = TRACE_SPEED

