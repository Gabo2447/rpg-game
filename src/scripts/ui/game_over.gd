extends Control

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
	queue_free()


func _on_left_button_pressed() -> void:
	# Ir al menu, pero por ahora cerrar el juego
	get_tree().quit()
