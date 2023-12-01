extends Node2D

var screen_size
var player_path

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	player_path = "/root/%s/Player"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Make sure the player is at 20% below the center of the screen
	if get_tree().root.get_child(0).has_node("Player"):
		var camera_pos = $Player.position
		camera_pos.y -= screen_size.y * .2
		$Camera.position = camera_pos
