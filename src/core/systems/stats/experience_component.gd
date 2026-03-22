extends Node
class_name ExperienceComponent

# --- CONFIGURACION ---
@export var stats: Stats # Arrastramos el MISMO Recurso de Stats que usa el HealthComponent

func _ready() -> void:
	if not stats:
		push_error("¡ERROR! ExperienceComponent sin Stats en: " + owner.name)

# Función para ganar XP (por matar enemigos, misiones, etc.)
func gain_experience(amount: int) -> void:
	if stats:
		stats.experience += amount
		print(owner.name, " ganó ", amount, " XP. Total: ", stats.experience, " | Nivel: ", stats.level)
