extends EnemyStateBase

func start():
	enemy.animation_playback.travel(enemy.anims.run)

func on_physics_process(delta: float) -> void:
	if !is_instance_valid(enemy.player):
		state_machine.change_to(enemy.state.Idle)
		return
	
	var dist = enemy.global_position.distance_to(enemy.player.global_position)
	if dist <= (enemy.attack_range - 5): 
		state_machine.change_to(enemy.state.Attack) 
		return
		
	if dist > (enemy.aggro_range + 20.0):
		state_machine.change_to(enemy.state.Idle)
		return
	
	enemy.navigation_agent.target_position = enemy.player.global_position
	
	var next_pos = enemy.navigation_agent.get_next_path_position()
	var velocity_direction = enemy.global_position.direction_to(next_pos)
	enemy.velocity = velocity_direction * enemy.speed
	
	if abs(enemy.velocity.x) > 0.1:
		enemy.sprite.flip_h = enemy.velocity.x < 0
	
	enemy.move_and_slide()
