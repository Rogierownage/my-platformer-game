extends CharacterBody2D
class_name Player

const SPEED: int = 100
const JUMP_VELOCITY: int = -170
const DEATH_PLANE_Y: int = 200

var double_jump_available: bool = true

@onready var animation: AnimatedSprite2D = $"AnimatedSprite2D"
@onready var coyoteTimer: Timer = $"Timer-coyote"
@onready var jumpSound: AudioStreamPlayer = $"Jump-sound"

func _physics_process(delta: float) -> void:	
	up_direction = -get_gravity()
	
	handleMovement(delta)
	handleDeathPlane()
	updateCoyoteTimer()
	updateDoubleJump()
	
	move_and_slide()
	
func handleMovement(delta: float) -> void:
	acceptMovementInput()
	acceptJumpInput()
	handleGravity(delta)

func handleGravity(delta: float) -> void:
	animation.flip_v = isGravityFlipped()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func isGravityFlipped() -> bool:
	return get_gravity()[1] < 0
		
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
	jumpSound.play()
	animation.play('jump')
	velocity.y = JUMP_VELOCITY
	
	if isGravityFlipped():
		velocity.y *= -1
	
func updateCoyoteTimer() -> void:
	if is_on_floor() and velocity.y >= 0:
		coyoteTimer.stop()
		coyoteTimer.start()
	
func updateDoubleJump() -> void:
	if is_on_floor():
		double_jump_available = true
		
func handleDeathPlane() -> void:
	if position.y >= DEATH_PLANE_Y:
		get_tree().reload_current_scene()
