extends Node

var isANewSceneLoading : bool = false
var sceneCurrentlyLoading : String = ""

var mainMenuNextSceneSwitch : String

var currentScene : Node = null
signal sceneSwitchStarted
signal sceneSwitchCompleted
# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	currentScene = root.get_child(root.get_child_count() - 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float):
	# If a scene is currently loading, update loading status
	if (isANewSceneLoading):
		var progress : Array[float] = [0.0]
		var status := ResourceLoader.load_threaded_get_status(sceneCurrentlyLoading, progress) 
		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				var loadPercent = progress[0] * 100
				print("Scene " + sceneCurrentlyLoading + " loading : " + str(loadPercent) + "%")
				$Control/ProgressBar.value = loadPercent
			ResourceLoader.THREAD_LOAD_FAILED | ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				# Error !! Signal it then abort scene switching
				push_error("Scene loading failed ! Wanted scene : " + sceneCurrentlyLoading)
				isANewSceneLoading = false
			ResourceLoader.THREAD_LOAD_LOADED:
				isANewSceneLoading = false
				$Control/ProgressBar.value = 100.0
				call_deferred("_completeSceneLoading", sceneCurrentlyLoading)

func gotoscn(path=""):
	if (isANewSceneLoading):
		push_warning("Scene " + path + "requested while already switching to " + sceneCurrentlyLoading)
		return
		
	# First, show the loading UI at 0%
#	$LoadingUI.loadPercent = 0.0
#	$LoadingUI.displayUI()
	$Control/ProgressBar.visible=true
	$Control/ProgressBar.value=0.0
	# Then start the loading process
	ResourceLoader.load_threaded_request(path)
	sceneCurrentlyLoading = path
	isANewSceneLoading = true
	
	# Emit the scene switch signal
	sceneSwitchStarted.emit()
	print("Switching to scene " + path)
	
	# Then remove current scene next idle time
	call_deferred("calddada")
func calddada():
	currentScene.queue_free()
##This fucntion is called whenever the scene loading is completed
func _completeSceneLoading(path : String) -> void:
	# Load & instanciate the new scene.
	var s = ResourceLoader.load_threaded_get(path)
	currentScene = s.instantiate()
	
	# Add it to the active scene, as child of root.
	get_tree().root.add_child(currentScene)
	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = currentScene
	
	# remove Loading UI & signal end of scene switching
	$Control/ProgressBar.visible=false
	sceneSwitchCompleted.emit()
	print("Scene switching completed")

func _on_music_toggled(toggled_on):
	AudioServer.set_bus_mute(1,toggled_on)

func _on_sfx_toggled(toggled_on):
	AudioServer.set_bus_mute(2,toggled_on)
