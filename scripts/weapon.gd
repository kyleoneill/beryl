extends RigidBody2D

@export var time_to_live = 7
var time_passed


# Called when the node enters the scene tree for the first time.
func _ready():
	time_passed = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	if time_passed >= time_to_live:
		queue_free()
