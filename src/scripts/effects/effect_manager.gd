extends Node2D

# --- FUNCIONES ---
func _ready() -> void:
	# Nos suscribimos a la señal global
	GameEvents.request_effect.connect(_on_effect_requested)

# Recibir el paquete, inicializarlo, agregarlo y ponerlo en la ubicacion correspondiente
func _on_effect_requested(effect_packed: PackedScene, global_pos: Vector2) -> void:
	if effect_packed:
		var effect_instance = effect_packed.instantiate()
		add_child(effect_instance)
		effect_instance.global_position = global_pos
