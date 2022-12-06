extends Node

signal on_scene_switch()

#
# Node/Scene References
#
onready var loading_screen = $LoadingScreen
onready var anim = $LoadingScreen/AnimationPlayer
onready var loading_progress = $LoadingScreen/ProgressBar

#
# Variables
#
onready var current_scene
onready var loaded_scene
onready var loader

# --- Scene Management ---
func load_new_scene(new_scene: String):
	emit_signal("on_scene_switch")
	print("Manager changing")
	
	loader = ResourceLoader.load_interactive(new_scene)
	
	if loader == null:
		print("ERROR: Error occured while getting the scene\n - Did you pass in the correct path?")
		return
	
	anim.play("fade-to-load")
	yield(anim, "animation_finished")
	
	# Load the scene
	while true:
		var error = loader.poll()
		
		# When a chunk is loaded
		if error == OK:
			# Update progress bar
			loading_progress.value = float(loader.get_stage()) / loader.get_stage_count() * 100
		
		# When data is done loading
		elif error == ERR_FILE_EOF:
			current_scene = new_scene
			
			#var scene = loader.get_resource().instance()
			get_tree().change_scene_to(loader.get_resource())
			
			anim.play("fade-to-game")
			loader = null
			return
		
		# Handle error
		else:
			print("ERROR: Error occured while loading data chunks")

func reload_current_scene():
	load_new_scene(current_scene)
