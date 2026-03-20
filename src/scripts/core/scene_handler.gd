extends Node

# --- CONFIGURACIONES ---
@export_category("Scenes")
@export var main_menu_packed: PackedScene
@export var game_scene_packed: PackedScene

# --- FUNCIONES ---
func _ready() -> void:
	load_main_menu("game start")

# --- AUXILIARES ---
func load_main_menu(origin: String) -> void:
	var main_menu: Control = main_menu_packed.instantiate()
	connect_main_menu_signals(main_menu)

	add_child(main_menu)

func connect_main_menu_signals(main_menu: Control) -> void:
	main_menu.connect("new_game_pressed", new_game)
	main_menu.connect("settings_pressed", settings_open)
	main_menu.connect("about_pressed", about_open)
	main_menu.connect("exit_pressed", exit_game)

# --- ACCIONES ---
func new_game(origin: String) -> void:
	if origin == "main_menu":
		get_node("MainMenu").queue_free() # Elimina el menú principal
	
	var game_scene: Node = game_scene_packed.instantiate()
	add_child(game_scene)
	
func settings_open(origin: String) -> void:
	# opens the settings menu
	print("Settings Pressed from: " + origin)
	pass

func about_open(origin: String) -> void:
	# opens the about menu
	print("About Pressed from: " + origin)

func exit_game(origin: String) -> void:
	get_tree().quit() # Cerrar Juego
	print("Exit Game Pressed from: " + origin)
