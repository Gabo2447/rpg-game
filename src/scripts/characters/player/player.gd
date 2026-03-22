extends CharacterBody2D
class_name Player

# --- CONFIGURACIONES (Mantenemos los exports aquí) ---
@export_group("Stats")
@export var speed: float = 300
@export var acceleration: float = 0.3 
@export var attack_damage: int = 60

@export_group("Nodes")
@export var sprite: Sprite2D
@export var animation_tree: AnimationTree
@export var death_packed: PackedScene
@export var experience_component: ExperienceComponent
@onready var health_component: HealthComponent = $HealthComponent 

@onready var anim_playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")


# Variable para que los estados lean el input
var move_direction: Vector2 = Vector2.ZERO

var states: PlayerStateNames = PlayerStateNames.new()
var animations: PlayerStateAnimations = PlayerStateAnimations.new()

func _ready() -> void:
	GameEvents.player_spawned.emit(self)
	GameEvents.experience_gained.connect(_on_experience_gained)
	health_component.get_health_depleted_signal().connect(_on_death)
	animation_tree.active = true

func _physics_process(_delta: float) -> void:
	move_direction = Input.get_vector("left", "right", "up", "down")

func _on_death():
	if death_packed:
		GameEvents.request_effect.emit(death_packed, global_position)
	else:
		print("ERROR: Olvidaste asignar el death_packed en el Inspector de: ", name)
	queue_free()

func _on_experience_gained(amount: int) -> void:
	# El jugador absorbe la XP
	experience_component.gain_experience(amount)
