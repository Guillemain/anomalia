extends Node2D


const marging := 10.0

func get_safe_area():
	#var area := $Area2D as Area2D
	#area.global_position = $RayCast2D.get_collision_point()
	if $RayCast2D.is_colliding():
		return $RayCast2D.get_collision_point() #+ to_global(Vector2.LEFT * marging)
	else:
		return global_position
	#area.position = Vector2.ZERO
	#for i in range(500):
		#area.position += Vector2.RIGHT * steps
		#var n_ngb = len(area.get_overlapping_bodies()) + len(area.get_overlapping_areas())
		#print(n_ngb)
		#if n_ngb == 0:
			#print("found ! ")
			#return area.global_position
		#await get_tree().physics_frame
		#
	#return area.global_position
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
