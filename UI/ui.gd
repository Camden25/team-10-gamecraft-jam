extends CanvasLayer
class_name UI

var boss_health: float
var boss_max_health: float
var boss_name: String

var player_health: float
var player_max_health: float

func _ready() -> void:
	add_to_group("ui")

func _process(_delta: float) -> void:
	update_boss_healthbar()

func update_boss_healthbar() -> void:
	$BossHealthbar/Health.size.x = (boss_health/boss_max_health) * 1330
	$BossHealthbar/BossName.text = boss_name
