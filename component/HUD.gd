extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_perc(new_percen):
	print(new_percen)
	var tw = get_tree().create_tween()
	tw.tween_property($a/ProgressBar,"value",new_percen,0.05)
	tw.tween_property($a/prox,"value",new_percen,0.5)
	var tw2 = get_tree().create_tween()
	$a.scale = Vector2(1.2,0.8)
	tw2.tween_property($a,"scale",Vector2(0.8,1.2),0.05)
	tw2.tween_property($a,"scale",Vector2(1.2,0.8),0.05)
	tw2.tween_property($a,"scale",Vector2(0.8,1.2),0.05)
	tw2.tween_property($a,"scale",Vector2.ONE,0.1)
