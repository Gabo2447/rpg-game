class_name PlayerStateBase extends StateBase

# --- VARIABLES ---
var player: Player

func _ready() -> void:
	await owner.ready # Esperamos a que el Player esté listo
	player = owner as Player
