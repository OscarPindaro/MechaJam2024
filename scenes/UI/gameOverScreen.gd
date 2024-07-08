extends Control

@export var game_manager : GameManager

func _ready():
    if is_instance_valid(game_manager):
        game_manager.game_over.connect(become_visible)

func become_visible():
    %WaveSurvivalText.text = "You've survived " + str(game_manager.get_wave_num()) + " waves, congratulations!"
    $CanvasLayer.visible = true
    get_tree().paused = true
