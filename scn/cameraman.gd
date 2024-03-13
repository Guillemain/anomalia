extends Node2D

signal tag

@onready var target : CharacterBody2D = $"../Player"

@export var dead_zone := 100
@export var speed := 0.5
var follow := true

var to_go := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	to_go = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): 
	if target == null:
		return
	position = lerp(position,to_go,delta*speed)
	if (position - target.position).length_squared() < dead_zone*dead_zone:
		follow = false
	else: 
		follow = true
	if not follow:
		return
	
	to_go = target.position  + target.velocity
	


func _on_menu_pressed():
	GlobalNode.gotoscn("res://scn/menu.tscn")


func _on_music_toggled(toggled_on):
	AudioServer.set_bus_mute(1,not(toggled_on))


func _on_sfx_toggled(toggled_on):
	AudioServer.set_bus_mute(2,not(toggled_on))
