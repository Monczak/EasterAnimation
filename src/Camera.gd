extends Node2D
class_name Camera

@onready var camera2d: Camera2D = $Camera2D

@export var shake_speed: float
@export var shake_delta: Vector2

var _initial_zoom: float

var _shake_power := 0.0

@onready var _shake_tween: Tween
@onready var _zoom_tween: Tween


func _ready() -> void:
    _initial_zoom = camera2d.zoom.x
    

func zoom(target_zoom: float, zoom_duration: float) -> void:
    if _zoom_tween != null:
        _zoom_tween.stop()
        
    _zoom_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
    var zoom_amount = _initial_zoom * target_zoom
    _zoom_tween.tween_property(camera2d, "zoom", Vector2(zoom_amount, zoom_amount), zoom_duration)


func shake(shake_tremor_power: float, shake_tremor_duration: float) -> void:
    if _shake_tween != null:
        _shake_tween.stop()
        
    _shake_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO)
    _shake_power = shake_tremor_power
    _shake_tween.tween_property(self, "_shake_power", 0, shake_tremor_duration)
    

func _process(delta: float) -> void:
    var time := Time.get_ticks_msec() / 1000.0
    var displacement = Vector2(sin(TAU * time * shake_speed), sin(TAU * time * shake_speed * 3.4 + 0.341))
    camera2d.position = displacement * shake_delta * _shake_power
