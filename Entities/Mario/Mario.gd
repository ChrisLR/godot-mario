extends KinematicBody2D


var Velocity = Vector2.ZERO;

var AirSpeed = 3
var GroundSpeed = 5
var MaxSpeed = 128
var HalfSpeed = MaxSpeed / 2

var airTime = 0

var JumpHeight = -225
var HalfJump = JumpHeight / 2
var Gravity = Vector2(0, 6)
var Jumping = false;

var coins: int = 0;
var isSmall: = true

onready var groundCast = $GroundCast
onready var startPoint = position
onready var CurrentSprite = $Small

var grounded = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func move_left():
	CurrentSprite.flip_h = true
	if Velocity.x > 0 and grounded:
		CurrentSprite.play("Slide")
	elif grounded:
		CurrentSprite.play("Move")
		
	if not grounded:
		Velocity.x -= AirSpeed
	else:
		Velocity.x -= GroundSpeed

func move_right():
	CurrentSprite.flip_h = false
	if Velocity.x < 0 and grounded:
		CurrentSprite.play("Slide")
	elif grounded:
		CurrentSprite.play("Move")
		
	if not grounded:
		Velocity.x += AirSpeed
	else:
		Velocity.x += GroundSpeed

func _physics_process(_delta):
	Velocity = move_and_slide(Velocity, Vector2.UP);
	grounded = groundCast.is_colliding() or is_on_floor();
	
	if Input.is_action_pressed("ui_right"):
		move_right()
	elif Input.is_action_pressed("ui_left"):
		move_left()
	else:
		# Not Moving
		if Velocity.x < 0:
			Velocity.x += 2
		elif Velocity.x > 0:
			Velocity.x -= 2
	
	if Input.is_action_pressed("ui_up") and grounded:
		Velocity.y = JumpHeight;
		$Small.play("Jump")
		Jumping = true
	elif grounded:
		airTime = 0
		if Velocity.x > -0.5 and Velocity.x < 0.2:
			$Small.play("Idle")
	
	if not grounded or Jumping:
		airTime += 1
		Velocity += Gravity
		Velocity.y += int(airTime / 2)
	else:
		if Velocity.x < 0:
			Velocity.x += 1
		elif Velocity.x > 0:
			Velocity.x -= 1
			
		Velocity.y = 1
	
	Velocity.x = clamp(Velocity.x, -MaxSpeed, MaxSpeed)
	


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
