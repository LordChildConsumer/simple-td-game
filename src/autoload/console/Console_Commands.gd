extends Node

enum {
	ARG_INT,
	ARG_STRING,
	ARG_BOOL,
	ARG_FLOAT
}
# Node References


# Constants
const valid_commands = [
	#["command", [ARG_TYPE, ARG_TYPE],
	["help", [], "Shows the full list of commands"]
]

# Variables


# -----------------------
# --- Godot Functions ---
# -----------------------

func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	pass


# ------------------------
# --- Custom Functions ---
# ------------------------

func help():
	var help_list = "Command List\n\n"
	for c in valid_commands:
		help_list += "%s | %s\n" % [c[0], c[2]]
	
	return help_list
