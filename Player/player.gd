extends CharacterBody2D

const SPEED: int = 300
const JUMP_VELOCITY: int = -500
var double_jump_available: bool = true
var coyote_timer_running: bool = false
var DEATH_PLANE_Y: int = 200

func _physics_process(delta: float) -> void:
	updateVelocity(delta)
	
	move_and_slide()
	
func updateVelocity(delta:float) -> void:
	acceptMovementInput(delta)
	updateCoyoteTimer()
	acceptJumpInput(delta)
	handleGravity(delta)
	updateDoubleJump()
	checkDeath()

func handleGravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func acceptJumpInput(delta: float) -> void:
	if not Input.is_action_just_pressed("jump"):
		return
		
	if coyote_timer_running:
		applyJump(delta)
		
		coyote_timer_running = false
		$"Timer-coyote".stop()
		
		return
	if double_jump_available:
		applyJump(delta)
		
		double_jump_available = false
		
		return

func acceptMovementInput(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
		
		$AnimatedSprite2D.flip_h = direction < 0
			
		return
	velocity.x = move_toward(velocity.x, 0, SPEED)

func applyJump(delta: float) -> void:
	$"Jump-sound".play()
	velocity.y = JUMP_VELOCITY
	
func updateCoyoteTimer() -> void:
	if is_on_floor() and not coyote_timer_running:
		coyote_timer_running = true
		$"Timer-coyote".stop()
		$"Timer-coyote".start()
	
func updateDoubleJump() -> void:
	if is_on_floor():
		double_jump_available = true
		
func checkDeath() -> void:
	if position.y > DEATH_PLANE_Y:
		get_tree().reload_current_scene()
	
func _on_timercoyote_timeout() -> void:
	coyote_timer_running = false
