extends Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready():
	polygon = ($"../Line2D" as Line2D).points


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
