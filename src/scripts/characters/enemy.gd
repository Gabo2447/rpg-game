extends CharacterBody2D

enum State {
	IDLE,
	CHASE,
	RETURN,
	ATTACK,
	DEAD
}

# --- CONFIGURACION ---
@export_category("Stats")
@export var speed: int = 128
@export var attack_damage: int = 10
@export var attacK_speed: float = 1.0
@export var hitpoints: int = 180
@export var aggro_range: float = 256.0
@export var attack_range: float = 80.0

@export_category("Related Scenes")
@export var death_packed: PackedScene

@export_category("Nodes")
@export var animation_tree: AnimationTree
@export var sprite: Sprite2D
@export var navigation_agent: NavigationAgent2D

@onready var animation_playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var spawn_point: Vector2 = global_position

# --- VARIABLES ---
var current_state: State = State.IDLE
var player: CharacterBody2D

# --- FUNCIONES ---
func _ready() -> void:
	# Recibir al jugador
	GameEvents.player_spawned.connect(_on_player_spawned)
	find_player()
	
	# Activar animaciones
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	if current_state == State.DEAD or current_state == State.ATTACK: return

	if distance_to_player() <= attack_range: 
		current_state = State.ATTACK
		attack()
		
	elif distance_to_player() <= aggro_range: 
		current_state = State.CHASE
		print("chasing")
		move()

	elif global_position.distance_to(spawn_point) > 32:
		current_state = State.RETURN

	else:
		current_state = State.IDLE
	update_animation()


# --- ACCIONES ---
func take_damage(damage_taken: int) -> void:
	hitpoints -= damage_taken
	if hitpoints <= 0:
		death()

func death() -> void:
	GameEvents.request_effect.emit(death_packed, global_position)
	queue_free()

# --- FUNCIONES AUXILIARES ---

func distance_to_player() -> float:
	if is_instance_valid(player):
		return global_position.distance_to(player.global_position)
	return 10000.0

func move() -> void:
	if not is_instance_valid(player): return
	
	# 1. Actualizar destino
	navigation_agent.target_position = player.global_position
	
	# 2. Obtener dirección (esto fallará si no hiciste el paso 2 de arriba)
	var next_path_pos = navigation_agent.get_next_path_position()
	var new_velocity = global_position.direction_to(next_path_pos) * speed
		
	# 3. Mover directamente (para debuguear rápido)
	velocity = new_velocity
	move_and_slide()

func update_animation() -> void:
	if sprite and velocity.x != 0:
		sprite.flip_h = velocity.x < 0
	
	if velocity == Vector2.ZERO and current_state != State.ATTACK:
		current_state = State.IDLE
	
	match current_state:
		State.IDLE: animation_playback.travel("idle")
		State.CHASE, State.RETURN: animation_playback.travel("run")
		State.ATTACK: pass # La animación de ataque se maneja en la función attack()
		State.DEAD: pass # La animación de muerte se maneja en la función death()

func attack() -> void: 
	current_state = State.ATTACK
	
	var player_pos: Vector2 = player.global_position
	var attack_dir: Vector2 = (player_pos - global_position).normalized()

	sprite.flip_h = attack_dir.x < 0 and abs(attack_dir.x) >= abs(attack_dir.y)
	
	animation_tree.set("parameters/attack/BlendSpace2D/blend_position", attack_dir)
	animation_playback.travel("attack")
	update_animation()

# --- AUXILIARES ---
func find_player():
	var player_node = get_tree().get_first_node_in_group("player")
	if player_node:
		player = player_node

func _on_player_spawned(player_node: CharacterBody2D):
	player = player_node

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("attack"): current_state = State.IDLE

func _on_hit_box_area_entered(area: Area2D) -> void:
	area.owner.take_damage(attack_damage)


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
