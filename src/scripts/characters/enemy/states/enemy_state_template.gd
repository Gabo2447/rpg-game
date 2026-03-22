class_name EnemyStateBase extends StateBase

# --- VARIABLES ---
var enemy: Enemy

func _ready() -> void:
	await owner.ready # Esperamos a que el Enemigo esté listo
	enemy = owner as Enemy

func start(): pass
func end(): pass
