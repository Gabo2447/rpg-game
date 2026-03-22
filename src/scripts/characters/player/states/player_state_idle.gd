extends PlayerStateBase

# --- VARIABLES ---
var move_direction: Vector2 = Vector2.ZERO

func start():
	player.anim_playback.travel(player.animations.idle)

func on_physics_process(delta: float) -> void:
	move_direction = Input.get_vector("left", "right", "up", "down")
	
	if move_direction != Vector2.ZERO:
		state_machine.change_to(player.states.Run)
		return
	
	player.velocity = player.velocity.move_toward(Vector2.ZERO, 50)
	player.move_and_slide()

func on_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		state_machine.change_to(player.states.Attack)
