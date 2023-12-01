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


func _on_body_entered(body):
	# TODO: What if we want an enemy to take more than a single hit?
	#       Enemies should have health and the missile should blow up and deal
	#       damage (with explosion animation) when hitting them, but only
	#       delete them if they run out of health
	# TODO: Enemy should drop loot when they die
	if(body.name == "enemy"):
		# Our missile hit an enemy, create an explosion animation
		var explosion_animation = preload("res://scenes/explosion.tscn").instantiate()
		get_parent().add_child(explosion_animation)
		
		# TODO: Explosion sound - https://www.youtube.com/watch?v=3q7SLBB_9EM
		#       Wind Waker KABOOM sound as placeholder
		
		# Play the animation and delete the missile and enemy
		explosion_animation.position = body.position
		explosion_animation.play("explosion")
		body.queue_free()
		queue_free()
