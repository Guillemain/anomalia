extends Node2D

const edge := preload("res://scn/looper/loop_edge.tscn")
const aberration := preload("res://scn/looper/Aberation.tscn")

var target : Node2D
var is_looping = false
var edge_list := []

var current_id := -1
var last_pos := Vector2.ZERO
var max_length = 20

func start_loop(itarget : Node2D, length=35):
	max_length=length
	$Timer.start()
	is_looping = true
	target = itarget
	last_pos = target.position

func create_sample():
	var to_draw = []
	
	if len(edge_list) != 0:
		edge_list[-1].monitorable = true
	current_id += 1
	var instance := edge.instantiate()
	add_child(instance)
	instance.set_a(last_pos)
	instance.set_b(target.global_position)
	
	
	instance.id = current_id
	last_pos = target.global_position
	edge_list += [instance]
	
	
	
	if (current_id-max_length) > 1:
		for i in range(0,current_id-max_length):
			if edge_list[i] != null:
				edge_list[i].visible = false
				edge_list[i].monitorable = false
			to_draw.pop_front()
	#clear_points()
	for i in range(current_id):
		if edge_list[i] != null:
			if edge_list[i].visible:
				to_draw += [edge_list[i].b]
	#($line as Line2D).position = PackedVector2Array(to_draw)
	($line as Line2D).clear_points()
	for p in to_draw:
		($line as Line2D).add_point(p)
	
func create_polygons_from_id(id:int):
	if len(edge_list) == 0:
		return PackedVector2Array([])
	var points_list = [edge_list[id].a] 
	
	for edge_id in range(id,len(edge_list)):
		points_list += [edge_list[edge_id].b]
	if len(points_list)<3:
		return PackedVector2Array([])

	#poly.set_point_cloud(PackedVector2Array(points_list))
	return PackedVector2Array(points_list)

func change_parent_of_edges(papa : Node2D, id:int):
	if len(edge_list) == 0:
		return PackedVector2Array([])
	var points_list = [edge_list[id].a]
	var new_list = []
	for edge_id in range(0,id):
		new_list += [edge_list[edge_id]]
	for edge_id in range(id,len(edge_list)):
		edge_list[edge_id].reparent(papa)
	edge_list = new_list


func end_loop(id:int):
	
	is_looping = false
	var poly : PackedVector2Array = create_polygons_from_id(id)
	reset_loop()
	if poly.size() < 3:
		return
	await get_tree().physics_frame
	var instance = aberration.instantiate()
	get_parent().add_child(instance)
	(instance.get_node("CollisionShape2D") as CollisionPolygon2D).polygon = poly
	instance.set_render(poly)
	instance.do_redux(1.0/60.0)
	await get_tree().create_timer(0.45).timeout
	if instance != null:
		instance.redux = true

func reset_loop():
	$Timer.stop()
	($line as Line2D).clear_points()
	for elem in edge_list:
		elem.queue_free()
	edge_list = []
	current_id = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if is_looping:
		create_sample()


func _on_player_sbonus():
	$line.default_color = Color.DARK_ORCHID
	var tw = get_tree().create_tween()
	tw.tween_property($line,"default_color",Color.BLACK,0.1).set_trans(Tween.TRANS_EXPO)
	tw.tween_property($line,"default_color",Color.DARK_ORCHID,0.1).set_trans(Tween.TRANS_EXPO)
	tw.tween_property($line,"default_color",Color.BLACK,0.1).set_trans(Tween.TRANS_EXPO)
	tw.tween_property($line,"default_color",Color.BLACK,0.1).set_trans(Tween.TRANS_EXPO)
	tw.tween_property($line,"default_color",Color.DARK_ORCHID,0.1).set_trans(Tween.TRANS_EXPO)
	tw.tween_property($line,"default_color",Color.BLACK,0.1).set_trans(Tween.TRANS_EXPO)
