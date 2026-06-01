extends Node2D

@onready var tree_sprite: Sprite2D = %TreeSprite
@onready var hurt_component: HurtComponent = %HurtComponent
@onready var damage_component: DamageComponent = %DamageComponent


var log_scene = preload("res://scenes/objects/trees/log.tscn")

var TREE_SHAKE_INTENSITY = 0.8
var TREE_SHAKE_INTENSITY_DEFAULT = 0.0
var TREE_SHAKE_INTERVAL = 1.0

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reached.connect(on_max_damaged_reached)


func on_hurt(hit_damage: int) -> void:
	var tree_material = tree_sprite.material as ShaderMaterial
	damage_component.apply_damage(hit_damage)
	tree_material.set_shader_parameter("shake_intensity", TREE_SHAKE_INTENSITY)
	await get_tree().create_timer(TREE_SHAKE_INTERVAL).timeout
	tree_material.set_shader_parameter("shake_intensity", TREE_SHAKE_INTENSITY_DEFAULT)


func on_max_damaged_reached() -> void:
	call_deferred("add_log_scene")
	queue_free()


func add_log_scene() -> void:
	var log_instance = log_scene.instantiate() as Node2D
	log_instance.global_position = global_position
	get_parent().add_child(log_instance)
