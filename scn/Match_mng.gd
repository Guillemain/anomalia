extends Node

signal undemoin
signal undeplus
signal playerhurted

signal sloose
signal swin
signal send

@export var n_peon := 40
@export var max_cluster := 7
@export var good_n_noob := 5
@export var hard_n := 10

var win := false
var loose := false
var ended := false

var spawned_peon := 0
var current_peon_dead := 0

func on_tick():
	if spawned_peon >= (n_peon - 7):
		var to_spawn := n_peon-spawned_peon
		print("il reste ",to_spawn)
		for i in range(to_spawn):
			$"../spwn_arg".do_spawn()
		return
	
	var n_mob := len(get_tree().get_nodes_in_group('peon'))
	if n_mob > hard_n:
		print("trop de mob")
		return
	
	if spawned_peon >= 2*n_peon/3:
		print("on passe en mode hard")
		$"../spawn_loulou".do_spawn()
		var to_spawn := hard_n-n_mob
		for i in range(to_spawn):
			$"../spwn_arg".do_spawn()
			
	if n_mob < good_n_noob: 
		print("Une slave de plus")
		$"../spwn_arg".do_spawn()
		if spawned_peon >= n_peon/4:
			print("t'as fait un quart")
			$"../spawn_loulou".do_spawn()
			$"../spwn_arg".do_spawn()
		
	if n_mob < max_cluster: 
		if spawned_peon >= n_peon/2:
			print("on passe en mode molo")
			$"../spawn_loulou".do_spawn()
			$"../spwn_arg".do_spawn()

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../spawn_loulou".spawned.connect(on_spawned)
	$"../spwn_arg".spawned.connect(on_spawned)
	current_peon_dead = n_peon
func on_spawned():
	spawned_peon += 1
	undeplus.emit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reload") and ended:
		get_tree().reload_current_scene()
	elif Input.is_action_just_pressed("reload"):
		$"../cameraman/Control/replay2".visible = true

func replay():
	get_tree().reload_current_scene()
	
func _on_peon_dead():
	current_peon_dead -= 1
	$"../cameraman/Control".change_perc(100*current_peon_dead/n_peon)
	undemoin.emit()
	if current_peon_dead <= 0:
		
		if ended:
			return
		ended = true
		win = true
		swin.emit()
func _on_player_dead():
	if ended:
		return
	ended = true
	loose = true
	
	for n in get_tree().get_nodes_in_group("peon"):
		n.target = null
	$"../cameraman/Control/GO".visible = true

	sloose.emit()
	
