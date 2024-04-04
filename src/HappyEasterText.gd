extends Sprite2D
class_name HappyEasterText

@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D


func appear() -> void:
    var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
    tween.tween_property(self, "scale", Vector2(1, 1), 1.4)
    sound.play()


func _ready() -> void:
    scale = Vector2.ZERO
