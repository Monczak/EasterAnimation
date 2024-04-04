extends Node2D
class_name Egg

@onready var upper_half: RigidBody2D = $UpperHalf
@onready var upper_half_collider: Area2D = upper_half.get_node("Area2D")
@onready var chick: Sprite2D = $ArtChick

@export var break_force: Vector2
@export var break_torque: float

@export var chick_movement_delta: Vector2
@export var chick_movement_duration: float

var _crack_percentage: float

@onready var crack_sprite: Sprite2D = $Crack
@onready var crack_particles: GPUParticles2D = $CrackParticles

@onready var bounce_audio: AudioStreamPlayer2D = $UpperHalf/BounceAudio
@onready var crack_audio: AudioStreamPlayer2D = $CrackAudio
@onready var explode_audio: AudioStreamPlayer2D = $ExplodeAudio
@onready var chick_audio: AudioStreamPlayer2D = $ChickAudio

@export var shake_speed := 4.0
@export var shake_amplitude := 30.0

var _shake_power := 0.0
var _shake_tween: Tween

var _open := false


func set_crack_percentage(value: float) -> void:
    _crack_percentage = value
    crack_audio.pitch_scale = remap(_crack_percentage, 0, 1, 0.8, 1.2)  
    crack_audio.play()


func break_open() -> void:
    _open = true
    crack_particles.emitting = true
    _crack_percentage = 0
    _pop_chick_up()
    
    upper_half.freeze = false
    await get_tree().process_frame
    
    upper_half.apply_central_impulse(break_force)
    upper_half.apply_torque_impulse(break_torque)
    
    explode_audio.play()


func _pop_chick_up() -> void:
    var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
    tween.tween_property(chick, "position", chick_movement_delta, chick_movement_duration)
    
    
func _play_bounce_audio() -> void:
    var volume = 20 * log(clamp(inverse_lerp(0, 1000, upper_half.linear_velocity.length()), 0, 1)) / log(10)
    bounce_audio.volume_db = volume
    bounce_audio.play()
    
    
func shake(power: float, duration: float):
    if _shake_tween != null:
        _shake_tween.stop()
    
    _shake_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
    _shake_power = power
    _shake_tween.tween_property(self, "_shake_power", 0, duration)
    

func _ready() -> void:
    upper_half_collider.body_entered.connect(func(body): _play_bounce_audio())
    

func _process(delta: float) -> void:    
    (crack_sprite.material as ShaderMaterial).set_shader_parameter("Reveal", _crack_percentage)
    
    if not _open:
        var time = Time.get_ticks_msec() / 1000.0
        var rot = sin(TAU * shake_speed * time) * _shake_power
        rotation = rot
