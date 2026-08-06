class_name InteractionArea extends Area2D

@export var action_name: String = "Interact" ## Text used for interaction prompt.

## Reference this script for interactions. [br]
## Within a [code]_ready()[/code] function, write something like this:
## [code]interaction_area.interact = Callable(self, "_on_interact")[/code][br]
## and create a function that matches the callable string.[br]
## Additionally, use an [code]await[/code] function to make the code asynchronous


var interact: Callable = func():
	pass


func _on_body_entered(body: Node2D) -> void:
	InteractionManager.register_area(self)


func _on_body_exited(body: Node2D) -> void:
	InteractionManager.unregister_area(self)
