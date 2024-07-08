extends AudioStreamPlayer

func _ready():
    if !playing:
        play()
