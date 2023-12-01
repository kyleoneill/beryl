extends Area2D

@export var speed = 50
@export var rotational_speed = 0.03
# TODO: engine_is_on makes it so that we avoid loading a sprite every frame, assuming
# that sprite loads are too expensive to do that. Is this actually necessary?
var engine_is_on
var velocity


# Called when the node enters the scene tree for the first time.
func _ready():
	engine_is_on = false
	$Sprite2D.texture = load("res://sprites/player/spaceship_engine_off.png")
	velocity = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_input(delta)


func handle_input(delta):
	# Movement
	var new_movement = 0
	if Input.is_action_pressed("down"):
		new_movement = -1
	if Input.is_action_pressed("up"):
		new_movement = 1
	if Input.is_action_pressed("left"):
		rotation -= rotational_speed
	if Input.is_action_pressed("right"):
		rotation += rotational_speed
	if new_movement != 0:
		var change_in_velocity = Vector2(speed * new_movement, 0)
		velocity += change_in_velocity.rotated(rotation - deg_to_rad(90))
		if !engine_is_on:
			# If a movement key is down, set sprite to engine on
			$Sprite2D.texture = load("res://sprites/player/spaceship_engine.png")
			engine_is_on = true
	else:
		if engine_is_on:
			# If no movement key is down, set sprite to engine off
			$Sprite2D.texture = load("res://sprites/player/spaceship_engine_off.png")
			engine_is_on = false
	if velocity.x != 0 || velocity.y != 0:
		# TODO: Do I want to add a force to our rigidbody instead?
		#       Should I change the Node2D to a rigidbody?
		#        ^ This would stop the overlap of having two colliders which is prob bad
		# We need to change our position depending on velocity and then lower velocity
		position += velocity * delta
		velocity.x *= .95 if abs(velocity.x) > 1 else 0
		velocity.y *= .95 if abs(velocity.y) > 1 else 0
	
	# Combat
	if Input.is_action_just_pressed("shoot"):
		# TODO: The missile should de-spawn after a certain number of seconds
		# TODO: When colliding with anybody (even the player) it should explode and deal damage
		
		# Spawn a missile, add it to the parent scene
		var missile = preload("res://scenes/weapons/missile.tscn").instantiate()
		get_parent().add_child(missile)
		
		# Set the position of the missile to just in front of our ship
		# Give the missile the same rotation as our ship
		var new_position = position
		new_position += Vector2(90, 0).rotated(rotation - deg_to_rad(90))
		missile.position = new_position
		missile.rotation = rotation
		
		# Give the missile velocity the direction it's facing
		# TODO: This looks really weird. Shooting when moving vs shooting when staying
		#       still is just strange. How to reconcile?
		var missile_velocity = Vector2(70000, 0).rotated(rotation - deg_to_rad(90))
		missile.apply_force(missile_velocity, Vector2.ZERO)
