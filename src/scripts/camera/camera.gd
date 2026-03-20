extends Node2D

# --- CONFIGURACIÓN ---
@export_category("Seguimiento")
@export var target_group_name: String = "player"
@export var smooth_speed: float = 5.0 # Velocidad del suavizado (lerp)

# --- VARIABLES ---
var target_node: Node2D = null

# --- FUNCIONES ---
func _ready() -> void:
	# Nos conectamos a la signal
	GameEvents.player_spawned.connect(_on_player_spawned)
	
	# Usamos find_target()
	find_target()

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target_node): return
	
	# Obtener la posicion
	var desired_position = target_node.global_position
	
	# Aplicamos los efectos
	global_position = global_position.lerp(desired_position, smooth_speed * delta)

# --- AUXILIARES ---
func find_target():
	var nodes = get_tree().get_nodes_in_group(target_group_name)
	if nodes.size() > 0:
		target_node = nodes[0]

func _on_player_spawned(player_node: CharacterBody2D):
	target_node = player_node
	global_position = target_node.global_position # Llevarlo al player
