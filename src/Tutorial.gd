extends TextureRect
class_name Tutorial

@onready var timer: Timer = $Timer

var _tween: Tween

var _orig_pos: Vector2
@export var oscillate_speed := 0.7
@export var oscillate_amplitude := 4.0


func appear(delay: float) -> void:
    timer.start(delay)
    

func disappear() -> void:
    timer.stop()
    _set_color(Color(1, 1, 1, 0))
    

func _ready() -> void:
    modulate = Color(1, 1, 1, 0)
    timer.timeout.connect(func(): _set_color(Color(1, 1, 1, 1)))
    _orig_pos = position
    

func _process(delta: float) -> void:
    position = _orig_pos + Vector2.UP * sin(TAU * Time.get_ticks_msec() / 1000.0 * oscillate_speed) * oscillate_amplitude
    

func _set_color(color: Color) -> void:
    if _tween != null:
        _tween.stop()
    
    _tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC)
    _tween.tween_property(self, "modulate", color, 0.4)
