# MechaJam

## Installation
Clone this repository.

## Helpers
There are some helpers node that you can put under a CharacterBody2D and they automatically should work. 
For example MouseFollowMovement, when added to the scene tree, will make your CharacterBody2D follow your mouse. You don't need to write any additional code.
Useful for fast prototiping

## Some Developement Tricks
You have a CharacterBody2D that has a vision cone. When an object of the group enemy is in your vision cone, you must display a sprite with a "!".
Here's how you can implement it.
1. Create you CharacterBody2D
2. Add an Area2D and give a cone shape.
3. Connect the signlas "area_entered" and "area_exited" to the CharacterBody2D. You can do it through the UI or by code. I suggest by code. Your CharacterBody2D should also have 2 functions, "on_vision_cone_entered" and "on_vision_cone_exited", that will be linked to the signals. 
4. Inside this function, check if the Area that has entered is in the "enemies" gropu
5. Now create your enemy with an Area2D.The area should be in the "enemies" group

You finished.
If you want to connect with code, write the following in the **ready()** method of the CharacterBody2D:

```gdscript
extends CharacterBody2D


func _ready():
    # connect the area interaction signals
	$VisionCone.area_entered.connect(on_vision_cone_entered)
	$VisionCone.area_exited.connect(on_vision_cone_exited)


func on_vision_cone_entered(area: Area2D):
	if area.is_in_group("enemies"):
		print("ciao entered")

func on_vision_cone_exited(area: Area2D):
	if area.is_in_group("enemies"):
		print("ciao exited")
```