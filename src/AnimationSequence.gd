extends Node2D

@onready var egg: Egg = $Scene/Egg
@onready var happy_easter_text: HappyEasterText = $Scene/HappyEasterText
@onready var camera: Camera = $Camera
@onready var tutorial: Tutorial = $Scene/CanvasLayer/Control/Tutorial

signal step_animation


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("AnimationStep"):
        step_animation.emit()


func delay(time: float) -> void:
    await get_tree().create_timer(time).timeout


func _play_animation() -> void:
    tutorial.appear(2)
    
    await step_animation
    
    tutorial.disappear()
    
    egg.set_crack_percentage(0.3)
    camera.shake(0.1, 0.3)
    camera.zoom(1.2, 0.3)
    
    tutorial.appear(2)
    
    await step_animation
    
    tutorial.disappear()
    
    egg.set_crack_percentage(0.7)
    camera.shake(0.1, 0.3)
    camera.zoom(1.6, 0.3)
    
    tutorial.appear(2)
    
    await step_animation
    
    tutorial.disappear()
    
    egg.set_crack_percentage(1)
    camera.shake(0.1, 0.3)
    camera.zoom(2, 0.3)
    
    await delay(1.4)
    
    egg.shake(0.1, 0.7)
    
    await delay(0.6)
    
    camera.zoom(1, 1.7)
    await delay(0.3)
    
    egg.shake(0.2, 0.8)
    await delay(0.8)
    
    egg.shake(0.35, 0.5)
    await delay(0.5)
    
    egg.shake(0.7, 0.4)
    await delay(0.4)
    
    camera.shake(1, 0.2)
    egg.break_open()
    
    await delay(2)
    
    happy_easter_text.appear()


func _ready() -> void:    
    _play_animation()
