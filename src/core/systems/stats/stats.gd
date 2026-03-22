extends Resource
class_name Stats

# --- ENUMS ---
enum BuffableStats {
	MAX_HEALTH,
	DEFENSE,
	ATTACK
}

# --- CONST ---
const BASE_LEVEL_XP: int = 100
const STAT_CURVES: Dictionary[BuffableStats, Curve] = {
	BuffableStats.MAX_HEALTH: preload("uid://bhklakw1t4sj4"),
	BuffableStats.DEFENSE: preload("uid://c7as642mtg4gb"),
	BuffableStats.ATTACK: preload("uid://bvbvnkmya2ugs")
}

# --- SIGNAL ---
signal health_depleted
signal health_changed(cur_health: float, max_health: float)

# --- CONFIGURACIONES ---
@export var base_max_health: float = 100.0
@export var base_defense: float = 15.0
@export var base_attack: float = 15.0
@export var experience: int = 0: set = _on_experience_set

var level: int: 
	get(): return floor(max(1.0, sqrt(experience / BASE_LEVEL_XP) + 0.5))
var current_max_health: float = 100.0
var current_defense: float = 15.0
var current_attack: float = 15.0

var health: float = 0.0: set = _on_health_set

var stat_buffs: Array[StatBuff] = []

# --- FUNCIONES ---
func _init() -> void:
	setup_stats.call_deferred()


func setup_stats() -> void:
	recalculate_stats()
	health = current_max_health

func add_buff(buff: StatBuff) -> void:
	stat_buffs.append(buff)
	recalculate_stats.call_deferred()

func remove_buff(buff: StatBuff) -> void:
	stat_buffs.erase(buff)
	recalculate_stats.call_deferred()

func _on_health_set(new_value: float) -> void:
	health = clampf(new_value, 0, current_max_health)
	health_changed.emit(health, current_max_health)
	if health <= 0:
		health_depleted.emit()


func _on_experience_set(new_value: int) -> void:
	var old_level: int = level
	experience = new_value

	if not old_level == level:
		recalculate_stats()

func recalculate_stats() -> void:
	var stat_multipliers: Dictionary = {} # Amount to multiply included stats by
	var stat_addends: Dictionary = {} # Amount to add to included stats
	
	for buff in stat_buffs:
		var stat_name: String = BuffableStats.keys()[buff.stat].to_lower()
		
		match buff.BuffType:
			StatBuff.BuffType.ADD:
				if not stat_addends.has(stat_name):
					stat_addends[stat_name] = 0.0
				stat_addends[stat_name] += buff.buff_amount
			
			StatBuff.BuffType.MULTIPLY:
				if not stat_multipliers.has(stat_name):
					stat_multipliers[stat_name] = 1.0
				stat_multipliers[stat_name] += buff.buff_amount
				
				if stat_multipliers[stat_name] < 0.0:
					stat_multipliers[stat_name] = 0.0
	
	var stat_sample_pos: float = (float(level) / 100.0) - 0.01
	current_max_health = base_max_health * STAT_CURVES[BuffableStats.MAX_HEALTH].sample(stat_sample_pos)
	current_defense = base_defense * STAT_CURVES[BuffableStats.DEFENSE].sample(stat_sample_pos)
	current_attack = base_attack * STAT_CURVES[BuffableStats.ATTACK].sample(stat_sample_pos)
	
	for stat_name in stat_multipliers:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) * stat_multipliers[stat_name])
		
	for stat_name in stat_addends:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) + stat_multipliers[stat_name]) # Si esta roto entonces poner stat_multipliers[stat_name] * stat_addends[stat_name] o algo asi
