extends Line2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tw = get_tree().create_tween()
	tw.tween_property(self,"width",20.0,0.1).set_ease(Tween.EASE_IN)
	tw.tween_property(self,"width",0.0,0.4).set_ease(Tween.EASE_OUT).finished.connect(queue_free)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
