extends KinematicBody2D

export (int) var speed = 1200
export (int) var jump_speed = -1800
export (int) var gravity = 4000
export (int) var dash_speed = 4000

var velocity = Vector2.ZERO

var attackFinished = true
var movementAnimations = true

func get_input():
	velocity.x = 0
	if attackFinished:
		if Input.is_action_pressed("ui_right"):
			velocity.x += speed
			$AnimatedSprite.flip_h = false;
			if movementAnimations:
				$AnimatedSprite.animation = "Walking"
		elif Input.is_action_pressed("ui_left"):
			velocity.x -= speed
			$AnimatedSprite.flip_h = true;
			if movementAnimations:
				$AnimatedSprite.animation = "Walking"
		elif is_on_floor() && attackFinished == true && movementAnimations == true:
			$AnimatedSprite.animation = "Idle"
		
	if Input.is_action_just_pressed("q") && !$"Timers/Boot Timer".time_left:
		$AnimatedSprite.animation = "Slash"
		CountdownBoot()
		$"UI/Boots/Boots Label".visible = true
		attackFinished = false
		if $AnimatedSprite.flip_h == true:
			$"Dash Affects/Dash Right".emitting = false
			$"Dash Affects/Dash Right".emitting = true
			velocity.x -= dash_speed
		else:
			$"Dash Affects/Dash Left".emitting = false
			$"Dash Affects/Dash Left".emitting = true
			velocity.x += dash_speed

		
	if Input.is_action_just_pressed("e") && is_on_floor() && !$"Timers/Shield Timer".time_left:
		CountdownSheild()
		$"UI/Shield/Shield Label".visible = true
		$AnimatedSprite.animation = "Spin"
		attackFinished = false
		
	if Input.is_action_just_pressed("shift") && is_on_floor() && !$"Timers/Sword Timer".time_left:
		CountdownSword()
		$"UI/Sword/Sword Label".visible = true
		$AnimatedSprite.animation = "Attack"
		attackFinished = false
	

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			movementAnimations = false
			$AnimatedSprite.animation = "Jump"
			velocity.y = jump_speed



func _on_AnimatedSprite_animation_finished():
	attackFinished = true
	movementAnimations = true
	$"Dash Affects/Dash Right".emitting = false
	$"Dash Affects/Dash Left".emitting = false

func CountdownSheild():
	$"Timers/Shield Timer".start()
func CountdownSword():
	$"Timers/Sword Timer".start()
func CountdownBoot():
	$"Timers/Boot Timer".start()

func _process(delta):
	$"UI/Shield/Shield Label".text = str(round($"Timers/Shield Timer".time_left))
	$"UI/Sword/Sword Label".text = str(round($"Timers/Sword Timer".time_left))
	$"UI/Boots/Boots Label".text = str(round($"Timers/Boot Timer".time_left))
	
	if !$"Timers/Shield Timer".time_left:
		$"UI/Shield/Shield Label".visible = false
	if !$"Timers/Boot Timer".time_left:
		$"UI/Boots/Boots Label".visible = false
	if !$"Timers/Sword Timer".time_left:
		$"UI/Sword/Sword Label".visible = false
