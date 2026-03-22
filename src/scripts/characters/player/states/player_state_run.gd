extends PlayerStateBase

var direction: Vector2

func start():
	player.anim_playback.travel(player.animations.run)

func on_physics_process(delta: float) -> void:
	var target_vel = player.move_direction * player.speed
	player.velocity = player.velocity.lerp(target_vel, player.acceleration)
	
	#if player.move_direction.length() < 0.1 and player.velocity.length() < 10.0:
	if player.move_direction == Vector2.ZERO:
		state_machine.change_to(player.states.Idle)
	
	if player.move_direction.x != 0:
		player.sprite.flip_h = player.move_direction.x < 0
	
	player.move_and_slide()

func on_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		state_machine.change_to(player.states.Attack)
