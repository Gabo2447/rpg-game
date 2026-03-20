extends CharacterBody2D

enum State { IDLE, ATTACK, RUN, DEAD }

# --- CONFIGURACIONES ---
@export_category("Animation")
@export var sprite: Sprite2D
@export var animation_tree: AnimationTree

@onready var animation_playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@export_category("Stats")
@export var speed: float = 200
@export var attack_speed: float = 0.8 # seg
@export var attack_damage: int = 60

# --- VARIABLES ---
var move_direction: Vector2 = Vector2.ZERO
var current_state: State = State.IDLE

# --- FUNCIONES ---
func _ready() -> void:
	if animation_tree:
		animation_tree.active = true
		animation_tree.set("parameters/attack/TimeScale", attack_speed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if current_state != State.DEAD and current_state != State.ATTACK:
			attack()

func _physics_process(delta: float) -> void:
	if not current_state == State.ATTACK:
		handle_input()
		apply_movement()
		
	update_animation()

# --- FUNCIONES AUXILIARES ---
func handle_input() -> void:
	move_direction = Input.get_vector("left", "right", "up", "down") # Direccion
	
	if move_direction != Vector2.ZERO: # Si la velocidad es diferente a cero
		current_state = State.RUN
		if sprite:
			sprite.flip_h = move_direction.x < 0
	else:
		current_state = State.IDLE

func apply_movement() -> void:
	if current_state == State.RUN:
		velocity = move_direction * speed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

func update_animation() -> void:
	match current_state:
		State.IDLE:
			animation_playback.travel("idle")
		State.RUN:
			animation_playback.travel("run")
		State.ATTACK:
			animation_playback.travel("attack")

func attack():
	if current_state == State.ATTACK: return
	current_state = State.ATTACK
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	var attack_dir: Vector2 = (mouse_pos - global_position).normalized()
	
	sprite.flip_h = attack_dir.x < 0 and abs(attack_dir.x) >= abs(attack_dir.y)
	
	animation_tree.set("parameters/attack/BlendSpace2D/blend_position", attack_dir)
	update_animation()
	
	await animation_tree.animation_finished
	current_state = State.IDLE


func _on_hit_box_area_entered(area: Area2D) -> void:
	area.owner.take_damage(attack_damage)
