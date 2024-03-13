extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_spv_change(new_pv):
	var tw2 = get_tree().create_tween()
	tw2.tween_property(self,"value",new_pv,0.2).set_trans(Tween.TRANS_EXPO)


func _on_player_pv_get():
	scale = Vector2(1.5,0.5)
	var twe = get_tree().create_tween()
	twe.tween_property(self,"scale",Vector2(0.8,1.2),0.1).set_trans(Tween.TRANS_ELASTIC)
	twe.tween_property(self,"scale",Vector2.ONE,0.1).set_trans(Tween.TRANS_ELASTIC)


func _on_player_pv_lost():
	var twe = get_tree().create_tween()
	modulate = Color.CRIMSON
	twe.tween_property(self,"modulate",Color.from_string("97f3bc",Color.BLACK),0.2).set_trans(Tween.TRANS_LINEAR)
	
