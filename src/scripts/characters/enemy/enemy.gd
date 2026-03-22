extends CharacterBody2D
class_name Enemy

# --- NODOS ---
@export_category("Nodes")
@export var animation_tree: AnimationTree
@export var sprite: Sprite2D
@export var navigation_agent: NavigationAgent2D
@export var health_component: HealthComponent
@export var state_machine: StateMachine

@export_group("Sistema de progresion")
@export var stats: Stats

# --- CONFIGURACION DE IA ---
@export_group("IA Stats")
@export var speed: int = 128
@export var aggro_range: float = 256.0
@export var attack_range: float = 80.0
@export var death_packed: PackedScene

@onready var animation_playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var spawn_point: Vector2 = global_position

var player: CharacterBody2D

var anims: EnemyStateAnimations = EnemyStateAnimations.new()
var state: EnemyStateNames = EnemyStateNames.new()
var dist

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	GameEvents.player_spawned.connect(func(p): player = p)
	health_component.get_health_depleted_signal().connect(_on_death)
	animation_tree.active = true
	
	animation_tree.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name: StringName):
	var state = state_machine.current_state
	if state.has_method("on_animation_finished"):
		state.on_animation_finished(anim_name)

func _on_death() -> void:
	GameEvents.request_effect.emit(death_packed, global_position)
	GameEvents.experience_gained.emit(randi_range(200, 300))
	queue_free()
