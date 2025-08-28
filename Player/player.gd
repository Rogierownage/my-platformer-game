extends CharacterBody2D

const SPEED: int = 300
const JUMP_VELOCITY: int = -500
const DEATH_PLANE_Y: int = 200
var double_jump_available: bool = true
@onready var animation = $"AnimatedSprite2D"
@onready var coyoteTimer = $"Timer-coyote"

func _physics_process(delta: float) -> void:
	handleMovement(delta)
	checkDeath()
	updateCoyoteTimer()
	updateDoubleJump()
	
	move_and_slide()
	
func handleMovement(delta:float) -> void:
	acceptMovementInput()
	acceptJumpInput()
	handleGravity(delta)

func handleGravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func acceptJumpInput() -> void:
	if not Input.is_action_just_pressed("jump"):
		return
		
	if !coyoteTimer.is_stopped():
		applyJump()
		
		coyoteTimer.stop()
		
		return
	if double_jump_available:
		applyJump()
		
		double_jump_available = false
		
		return

func acceptMovementInput() -> void:
	var shouldPlayAnimation = is_on_floor()
	var direction := Input.get_axis("left", "right")
	
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if shouldPlayAnimation: animation.play('idle')
		
		return
		
	velocity.x = direction * SPEED
	
	animation.flip_h = direction < 0
	
	if shouldPlayAnimation: animation.play('run')
	
func applyJump() -> void:
	$"Jump-sound".play()
	animation.play('jump')
	velocity.y = JUMP_VELOCITY
	
func updateCoyoteTimer() -> void:
	
	if is_on_floor() and velocity.y >= 0:
		coyoteTimer.stop()
		coyoteTimer.start()
	
func updateDoubleJump() -> void:
	if is_on_floor():
		double_jump_available = true
		
func checkDeath() -> void:
	if position.y > DEATH_PLANE_Y:
		get_tree().reload_current_scene()
