extends CanvasLayer

func fade_in_out(waveNum):
    %EndWaveLabel.text = "Wave " + str(waveNum) + " completed!"
    $AnimationPlayer.current_animation = "fade_in_fade_out"
