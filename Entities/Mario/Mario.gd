extends KinematicBody2D


var Velocity = Vector2.ZERO;
var Accel = Vector2.ZERO
var MaxSpeed = 128
var Gravity = Vector2(0, 1)
var Jumping = false;

var coins: int = 0;

onready var groundCast = $GroundCast


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	pass
		

func _physics_process(delta):
	var isGrounded = groundCast.is_colliding() or is_on_floor();
	if Input.is_action_pressed("ui_right"):
		$Small.flip_h = false
		if Accel.x < 0:
			if isGrounded:
				$Small.play("Slide")
			Accel.x += 2;
		else:
			if isGrounded:
				$Small.play("Move")
		Accel.x += 1;
	elif Input.is_action_pressed("ui_left"):
		$Small.flip_h = true
		if Accel.x > 0:
			if isGrounded:
				$Small.play("Slide")
			Accel.x -= 2;
		else:
			if isGrounded:
				$Small.play("Move")
		Accel.x -= 1;
	else:
		Accel.x = 0;
	
	if Jumping:
		var collider = $CeilingCast.get_collider()
		if collider and collider.has_method("on_bump"):
			collider.on_bump(self)
	
	if Input.is_action_pressed("ui_up") and isGrounded:
		Velocity.y = -256;
		$Small.play("Jump")
		Jumping = true
	elif isGrounded and Jumping:
		if Accel.x != 0:
			$Small.play("Move")
		else:
			$Small.play("Idle")
	
	if not isGrounded:
		Accel.y += 1
	else:
		Accel.y = 0
	
	Velocity += Accel;
	
	Velocity.x = clamp(Velocity.x, -MaxSpeed, MaxSpeed)
	Accel.x = clamp(Accel.x, -MaxSpeed, MaxSpeed)
	Velocity = move_and_slide(Velocity, Vector2.UP);
	
	Velocity.x = lerp(Velocity.x, 0, 0.2)
	

func add_coin(value):
	coins += value
