extends Node2D

@onready var pause_menu: Control = $CanvasLayer/PauseMenu
@onready var player: Player = %Player
@onready var enemy_spawner: Node2D = %EnemySpawner
@onready var loot_base: Node2D = %Loot
@onready var level_up_panel: TextureRect = get_node("CanvasLayer/LevelUpMenu/LevelUpPanel")
@onready var upgrade_options: VBoxContainer = get_node("CanvasLayer/LevelUpMenu/LevelUpPanel/UpgradeOptions")

func _ready() -> void:
	GameManager.set_player(player)
	GameManager.set_enemy_spawner(enemy_spawner)
	GameManager.set_loot_base(loot_base)
	ExperienceManager.set_level_up_panel(level_up_panel)
	ExperienceManager.set_upgrade_options(upgrade_options)
	ExperienceManager.set_player(player)
	
	if GameManager.has_save_file():
		GameManager.load_game()
		
	$Fade_transition.show()
	$Fade_transition/AnimationPlayer.play("fade_out")
	
	process_mode = Node.PROCESS_MODE_PAUSABLE
