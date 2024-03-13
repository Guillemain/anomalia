extends Area2D


var id := 0

var a := Vector2.ZERO
var b := Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.shape = ($CollisionShape2D.shape as SegmentShape2D).duplicate()
	
	
func set_a(pos : Vector2):
	a = pos
	($CollisionShape2D.shape as SegmentShape2D).a = pos

func set_b(pos : Vector2):
	b = pos
	($CollisionShape2D.shape as SegmentShape2D).b = pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
