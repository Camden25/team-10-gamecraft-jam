extends CanvasLayer
class_name UI

var boss_health: float
var boss_max_health: float
var boss_name: String

var player_health: float
var player_max_health: float

var player_ability: float
var player_max_ability: float

var player_icon: int = 2

func _ready() -> void:
	add_to_group("ui")

func _process(_delta: float) -> void:
	update_boss_healthbar()
	update_player_bars()
	update_player_icon()

func update_boss_healthbar() -> void:
	$BossHealthbar/Health.size.x = (boss_health/boss_max_health) * 1330
	$BossHealthbar/BossName.text = boss_name

func update_player_bars() -> void:
	$Player/PlayerHealthbar/Health.size.x = (player_health/player_max_health) * 269
	$Player/PlayerAbilityBar/Ability.size.x = (player_ability/player_max_ability) * 199

func update_player_icon() -> void:
	$Player/PlayerAbility/Icon.frame = player_icon
