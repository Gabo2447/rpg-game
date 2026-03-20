extends Node2D

# --- CONFIGURACION ---
@export var anim_player: AnimationPlayer

# --- FUNCIONES ---
func _ready() -> void:
	if anim_player:
		anim_player.play("death")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
