extends KinematicBody2D


var Velocity = Vector2.ZERO;
var Accel = Vector2.ZERO

var MaxSpeed = 128
var HalfSpeed = MaxSpeed / 2

var JumpHeight = -225
var HalfJump = JumpHeight / 2
var Gravity = Vector2(0, 0.5)
var Jumping = false;

var coins: int = 0;

onready var groundCast = $GroundCast
onready var startPoint = position


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func on_change_direction(isGrounded):
	if Accel.x > 0:
		$Small.flip_h = false
	elif Accel.x < 0:
		$Small.flip_h = true
	
	Accel.x = 0
	if isGrounded:
		$Small.play("Slide")


func _physics_process(_delta):
	var isGrounded = groundCast.is_colliding() or is_on_floor();
	if Input.is_action_pressed("ui_right"):
		if Velocity.x < 0:
			on_change_direction(isGrounded)
		else:
			if isGrounded:
				$Small.play("Move")
		Accel.x += 1;
	elif Input.is_action_pressed("ui_left"):
		if Velocity.x > 0:
			if isGrounded:
				on_change_direction(isGrounded)
		else:
			if isGrounded:
				$Small.play("Move")
		Accel.x -= 1;
	else:
		Accel.x = 0;
	
	if Input.is_action_pressed("ui_up") and isGrounded:
		Velocity.y = JumpHeight;
		$Small.play("Jump")
		Jumping = true
	elif isGrounded and Jumping:
		if Accel.x != 0:
			$Small.play("Move")
		else:
			$Small.play("Idle")
	
	if not isGrounded:
		Accel.y += Gravity.y
	else:
		Accel.y = 0
	
	Velocity += Accel;
	
	Velocity.x = clamp(Velocity.x, -MaxSpeed, MaxSpeed)

	Accel.x = clamp(Accel.x, -HalfSpeed, HalfSpeed)
	Velocity = move_and_slide(Velocity, Vector2.UP);
	
	Velocity.x = lerp(Velocity.x, 0, 0.3)


func add_coin(value):
	coins += value

func on_damage():
	pass
	
func respawn():
	position = startPoint


func _on_AreaHead_body_entered(body):
	if Jumping and body.has_method("on_bump"):
		body.on_bump(self)


func _on_AreaFeet_body_entered(body):
	if body.has_method("on_crush"):
		body.on_crush(self)
	Jumping = true
	Velocity.y = HalfJump;
	$Small.play("Jump")
	
func _on_AreaBody_body_entered(body):
	if body.has_method("on_attack"):
		body.on_attack(self)
		self.on_damage()
