extends Sprite2D

signal sanim_end

@export var direction_disred := Vector2(0.0,-1.0)
@onready var viewport = $SubViewport
@export var dupli_mat = false
func _ready():
	if dupli_mat:
		material = material.duplicate()
	if has_node("SubViewport/obj/AnimationPlayer"):
		(get_node("SubViewport/obj/AnimationPlayer") as AnimationPlayer).animation_finished.connect(anim_end)

func orient(direction : Vector2):
	($SubViewport/pivot as Node3D).rotation.y = Vector2(0,1).angle_to(direction)
	
func play(animname : String,speed=1.0):
	if has_node("SubViewport/obj/AnimationPlayer"):
		$SubViewport/obj/AnimationPlayer.play(animname)
		(get_node("SubViewport/obj/AnimationPlayer") as AnimationPlayer).speed_scale = speed

func anim_end(a):
	sanim_end.emit()

func make_blink():

	material.set_shader_parameter("add_l",1.0)
	for i in range(2):
		for j in range(2):
			await get_tree().physics_frame
		material.set_shader_parameter("add_l",0.0)
		for j in range(2):
			await get_tree().physics_frame
		material.set_shader_parameter("add_l",1.0)
	material.set_shader_parameter("add_l",0.0)
