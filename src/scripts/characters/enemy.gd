extends CharacterBody2D

# --- CONFIGURACION ---
@export_category("Stats")
@export var hitpoints: int = 180

@export_category("Related Scenes")
@export var death_packed: PackedScene

# --- FUNCIONES ---
func take_damage(damage_taken: int) -> void:
	hitpoints -= damage_taken
	if hitpoints <= 0:
		death()

func death() -> void:
	GameEvents.request_effect.emit(death_packed, global_position)
	queue_free()
