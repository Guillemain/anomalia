extends Node2D


var first_move = true


func makeit_pop(node : Control,time=1):
	node.rotation = 0.2
	var tw = get_tree().create_tween()
	for i in range(time):
		tw.tween_property(node,"rotation",-0.2,0.1*time).set_trans(Tween.TRANS_ELASTIC)
		tw.tween_property(node,"rotation",0.2,0.1*time).set_trans(Tween.TRANS_ELASTIC)
	tw.tween_property(node,"rotation",0.0,0.1*time).set_trans(Tween.TRANS_ELASTIC)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_move():
	if first_move:
		$Control/move2.visible = true
		makeit_pop($Control/move2)
		first_move = false
		
func _on_before_aberration_area_entered(area):
	$Control/aber.visible = true
	makeit_pop($Control/aber)
	await get_tree().create_timer(0.2).timeout
	$Control/aber2.visible = true
	makeit_pop($Control/aber2)

func _on_after_abberation_area_entered(area):
	$Control/aber3.visible = true
	makeit_pop($Control/aber3)
	await get_tree().create_timer(0.2).timeout
	$Control/eye.visible = true
	makeit_pop($Control/eye)
	#$Aberation.destroy_it()


func _on_peon_dead():
	$Control/eye2.visible = true
	makeit_pop($Control/eye2)
	$Control/eye.visible = false
	$Control/aber3.visible = false
	$Control/aber2.visible = false
	$Control/aber.visible = false
	
	await get_tree().create_timer(0.2).timeout
	$Control/Button.visible = true
	makeit_pop($Control/Button,10)
	$letgo.monitoring= true


func _on_letgo_body_entered(body):
	GlobalNode.gotoscn("res://scn/main.tscn")


func _on_button_pressed():
	GlobalNode.gotoscn("res://scn/main.tscn")
