extends Area2D
class_name HealthComponent

# --- CONFIGURACION ---
@export var stats: Stats

# --- FUNCIONES ---
func _ready() -> void:
	if not stats:
		push_error("¡OJO! El HealthComponent de " + owner.name + " no tiene Stats asignadas.")
		return
	
	stats = stats.duplicate() # Evitar que todos los enemigos tengan la misma vida
	stats.setup_stats()

func take_damage(amount: int) -> void:
	if not stats: return
	var final_damage = max(1.0, amount - stats.current_defense)
	stats.health -= final_damage
	
	print(owner.name, " recibió ", final_damage, " de daño. Vida restante: ", stats.health)

func get_health_depleted_signal() -> Signal:
	return stats.health_depleted
