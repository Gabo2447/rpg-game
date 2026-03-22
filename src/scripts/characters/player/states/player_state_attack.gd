extends PlayerStateBase

func start() -> void:
	var mouse_pos = player.get_global_mouse_position()
	var attack_dir = (mouse_pos - player.global_position).normalized()
	
	player.sprite.flip_h = attack_dir.x < 0 and abs(attack_dir.x) >= abs(attack_dir.y)
	
	player.animation_tree.set("parameters/attack/BlendSpace2D/blend_position", attack_dir)
	player.anim_playback.travel(player.animations.attack)
	
	player.velocity = Vector2.ZERO

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	state_machine.change_to(player.states.Idle)
