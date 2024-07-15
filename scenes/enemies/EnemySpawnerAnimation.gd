extends AnimatedSprite2D

@export var game_manager : GameManager

func _ready():
    if is_instance_valid(game_manager):
        randomize()
        frame = randi_range(0, sprite_frames.get_frame_count(animation) - 1)
        game_manager.wave_start.connect(func(_num): play())
        game_manager.wave_end.connect(func(_num): stop())
