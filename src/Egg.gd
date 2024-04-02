extends Node2D

@onready var upper_half: RigidBody2D = $UpperHalf
@onready var chick: Sprite2D = $ArtChick

@export var break_force: Vector2
@export var break_torque: float

@export var chick_movement_delta: Vector2
@export var chick_movement_duration: float


func break_open() -> void:
    _pop_chick_up()
    await get_tree().create_timer(chick_movement_duration / 2 - 0.1).timeout
    
    upper_half.freeze = false
    await get_tree().process_frame
    upper_half.apply_central_impulse(break_force)
    upper_half.apply_torque_impulse(break_torque)


func _pop_chick_up() -> void:
    var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC)
    tween.tween_property(chick, "position", chick_movement_delta, chick_movement_duration)
    

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("ui_up"):
        break_open()
