extends Node2D

@onready var rock_sprite: Sprite2D = %RockSprite
@onready var hurt_component: HurtComponent = %HurtComponent
@onready var damage_component: DamageComponent = %DamageComponent

var stone_scene = preload("res://scenes/objects/rocks/stone.tscn")

var ROCK_SHAKE_INTENSITY = 0.7
var ROCK_SHAKE_INTENSITY_DEFAULT = 0.0
var ROCK_SHAKE_INTERVAL = 0.5


func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reached.connect(on_max_damaged_reached)


func on_hurt(hit_damage: int) -> void:
	var rock_material = rock_sprite.material as ShaderMaterial
	damage_component.apply_damage(hit_damage)
	rock_material.set_shader_parameter("shake_intensity", ROCK_SHAKE_INTENSITY)
	await get_tree().create_timer(ROCK_SHAKE_INTERVAL).timeout
	rock_material.set_shader_parameter("shake_intensity", ROCK_SHAKE_INTENSITY_DEFAULT)



func on_max_damaged_reached() -> void:
	call_deferred("add_stone_scene")
	queue_free()


func add_stone_scene() -> void:
	var stone_instance = stone_scene.instantiate() as Node2D
	stone_instance.global_position = global_position
	get_parent().add_child(stone_instance)
