extends EnemyStateBase

func start():
	enemy.velocity = Vector2.ZERO
	enemy.animation_playback.travel(enemy.anims.idle)
	
func on_physics_process(delta: float) -> void:
	if !is_instance_valid(enemy.player): return
	
	var dist = enemy.global_position.distance_to(enemy.player.global_position)
	if dist <= enemy.aggro_range:
		state_machine.change_to(enemy.state.Chase)
