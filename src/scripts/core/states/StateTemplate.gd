class_name StateBase
extends Node

@onready var controlled_node: Node = self.owner
var state_machine: StateMachine

# --- FUNCIONES ---
func start() -> void:
	pass # Se inicia al empezar el estado

func exit() -> void:
	pass # Se ejecuta al cambiar el estado
