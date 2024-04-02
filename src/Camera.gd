extends Node2D

@onready var camera2d: Camera2D = $Camera2D

@export var shake_speed: float
@export var shake_delta: Vector2

@export var shake_tremor_power: float
@export var shake_tremor_duration: float

var _shake_power := 0.0

@onready var _shake_tween: Tween


func shake() -> void:
    if _shake_tween != null:
        _shake_tween.stop()
        
    _shake_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO)
    _shake_power = shake_tremor_power
    _shake_tween.tween_property(self, "_shake_power", 0, shake_tremor_duration)
    

func _process(delta: float) -> void:
    var time := Time.get_ticks_msec() / 1000.0
    var displacement = Vector2(sin(TAU * time * shake_speed), sin(TAU * time * shake_speed * 3.4 + 0.341))
    camera2d.position = displacement * shake_delta * _shake_power
    
    if Input.is_action_just_pressed("ui_down"):
        shake()
