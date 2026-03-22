extends EnemyStateBase

func start():
	if !is_instance_valid(enemy.player):
		state_machine.change_to(enemy.anims.idle)
		return
	
	var attack_dir = enemy.global_position.direction_to(enemy.player.global_position)
	enemy.sprite.flip_h = attack_dir.x < 0 and abs(attack_dir.x) >= abs(attack_dir.y)
	
	enemy.animation_tree.set("parameters/attack/BlendSpace2D/blend_position", attack_dir)
	enemy.animation_playback.travel(enemy.anims.attack)
	
	enemy.velocity = Vector2.ZERO

func on_animation_finished(_anim_name: StringName) -> void:
	state_machine.change_to(enemy.state.Idle)
