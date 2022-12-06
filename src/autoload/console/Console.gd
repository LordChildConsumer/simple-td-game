extends Control

# Node References
onready var input_box = $Input
onready var output_box = $Output

onready var command_handler = $Commands

# Constants


# Variables
var command_history = []
var command_history_line = command_history.size()

# -----------------------
# --- Godot Functions ---
# -----------------------

func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	pass

func _input(event):
	# Toggle visibility
	if Input.is_action_just_pressed("debug"):
		visible = !visible
	
	# Go through command history with arrow keys
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_UP:
			cycle_command_history(-1)
		if event.scancode == KEY_DOWN:
			cycle_command_history(1)

# ------------------------
# --- Custom Functions ---
# ------------------------

# On open/close
func _on_Console_visibility_changed():
	if visible:
		get_tree().paused = true
		input_box.grab_focus()
	else:
		get_tree().paused = false
		input_box.release_focus()

# Output text to console
func output_text(text):
	output_box.text = str(output_box.text, "\n", text)
	output_box.set_v_scroll(999999)

# Receive input
func _on_Command_Entered(new_text):
	input_box.clear()
	process_command(new_text)
	command_history_line = command_history.size()

# Process commands
func process_command(text):
	# Commands
	var words = text.split(" ")
	words = Array(words)
	
	for i in range(words.count("")):
		words.erase("")
	
	
	if words.size() <= 0:
		return
	
	# Add the latest command to history
	command_history.append(text)
	
	var command_word = words.pop_front()
	
	# Check if the command is valid
	for c in command_handler.valid_commands:
		if c[0] == command_word:
			
			# If there are not enough params given
			if words.size() != c[1].size():
				output_text('Failure to execute "%s" | Expected %s parameters.' % [command_word, c[1].size()])
				return
			# If there are enough params given
			if words.size() < 1:
				output_text(command_handler.callv(command_word, words))
				return
			
			for i in range(words.size()):
				# If the wrong params are given
				if not check_type(words[i], c[1][i]):
					output_text('Failure to execute "%s" | Parameter %s (%s) is of the wrong type' % [command_word, (i + 1), words[i]])
					return
				# If the command actually works
				output_text(command_handler.callv(command_word, words))
				return
	output_text('Command "%s" does not exist' % command_word)

# Function to make sure params are the type needed
func check_type(string, type):
	match type:
		command_handler.ARG_INT:
			return string.is_valid_integer()
		command_handler.ARG_FLOAT:
			return string.is_valid_float()
		command_handler.ARG_STRING:
			return true
		command_handler.ARG_BOOL:
			return (string == "true" or string == "false")
		_:
			return false

# Move place in command history up/down
func cycle_command_history(offset):
	command_history_line += offset
	command_history_line = clamp(command_history_line, 0, command_history.size() + 1)
	
	if command_history_line < command_history.size() and command_history.size() > 0:
		input_box.text = command_history[command_history_line]
		
		# For some reason calling this doesn't work any other way
		input_box.call_deferred("set_cursor_position", 99999)
	else:
		input_box.clear()
