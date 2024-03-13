extends Node2D

signal spawned

@export var to_spawn : PackedScene

@export var spwn_pt : Array[Vector2]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func do_spawn():
	var pos = spwn_pt[randi_range(0,len(spwn_pt)-1)]
	var instance := to_spawn.instantiate() as Node2D
	get_parent().add_child(instance)
	instance.position = pos
	if instance.has_signal("dead"):
		instance.dead.connect($"../manager"._on_peon_dead)
	spawned.emit()
	
func _on_timer_timeout():
	do_spawn()
	
	
