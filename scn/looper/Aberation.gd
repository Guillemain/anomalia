extends Area2D

var redux_vitesse = 7.0
const edge := preload("res://scn/looper/aber_edge.tscn")

@export var auto_check = false 
@export var auto_redux = true
@export var can_destroy = true
@export var smooth_step = 40
@export var lifetime := 5


var redux = false
var e_list = []
var bbox_area = 0

var iter := 0

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	if (len($CollisionShape2D.polygon) > 0) and auto_check:
		set_render($CollisionShape2D.polygon)
		do_redux(1.0/60.0)
	if auto_redux:
		$Timer.start()

func do_redux(delta):
	var max_x = 0
	var max_y = 0
	var min_x = 10000000
	var min_y = 10000000
	
	
	var shape : PackedVector2Array = $CollisionShape2D.polygon
	var new_shape = []
	var n_pt = shape.size()
	for i in range(n_pt):
		var a := shape[(i-1)%n_pt]
		var b := shape[i]
		var c := shape[(i+1)%n_pt]
		var normal := (a+c)/2.0-b
		new_shape += [b+normal*delta*redux_vitesse]
		
		max_x = max(max_x,b.x)
		max_y = max(max_y,b.y)
		min_x = min(min_x,b.x)
		min_y = min(min_y,b.y)
	$CollisionShape2D.polygon = new_shape
	set_render(PackedVector2Array(new_shape))
	if can_destroy:
		if (max_x-min_x) < 100 :
			queue_free()
		if (max_y-min_y) < 100 :
			queue_free()

func create_poly_edge(edge_list):
	for e in edge_list:
		var instance := edge.instantiate()
		add_child(instance)
		instance.set_a(e[0])
		instance.set_b(e[1])
		e_list += [instance]

func set_render(poly : PackedVector2Array):
	($RenderShape as Polygon2D).polygon = poly
	if len(e_list) ==0 :
		var edges_raw = []
		var a = poly[0]
		for next in poly : # un erreur ici mais passons.
			edges_raw += [[a,next]]
			a = next
		edges_raw += [[a, poly[0]]]
		create_poly_edge(edges_raw)
	else:
		var a = poly[0]
		for i in range(len(poly)) : 
			var next = poly[i]
			e_list[i].set_a(a)
			e_list[i].set_b(next)
			a = next
		e_list[len(poly)].set_a(a)
		e_list[len(poly)].set_b(poly[0])
#func _draw():
	#draw_polyline(($RenderShape as Polygon2D).polygon, Color.BLACK,5.0,true)

func _physics_process(delta):
	if redux:
		iter -= 1
		if iter > 0 :
			do_redux(delta)
		if auto_redux and (iter == 0):
			$Timer.start()
	#if iter == 120:
		#get_tree().create_timer(1.5).timeout.connect(redo)

func redo():
	redux = true
	
func _on_timer_timeout():
	lifetime -= 1 
	if can_destroy and (lifetime<=0):
		queue_free()
	redux = true
	iter = smooth_step
	
func destroy_it():
	queue_free()
