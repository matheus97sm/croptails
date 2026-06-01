class_name CropsCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer
@export var plants: Array[Plant] = []
@export var minimun_crop_distance: float = 20.0

@onready var player: Player = get_tree().get_first_node_in_group("player")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_crop()
			return
	
	if event.is_action_pressed("hit"):		
		for plant: Plant in plants:
			if ToolManager.selected_tool == plant.crop_tool:
				get_cell_under_mouse()
				add_crop()
				break


func get_cell_under_mouse() -> void:
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)


func add_crop() -> void:
	var is_tilled_soil_terrain = cell_source_id != -1
	
	if !is_tilled_soil_terrain:
		return
	
	if distance < minimun_crop_distance && !get_has_crop():
		for plant: Plant in plants:
			if plant.crop_tool == ToolManager.selected_tool:
				var new_plant = plant.scene.instantiate() as Node2D
				new_plant.global_position = local_cell_position
				get_parent().find_child("CropFields").add_child(new_plant)
				break


func get_has_crop() -> bool:
	var has_crop = false
	var crop_nodes = get_parent().find_child("CropFields").get_children()
	
	for crop_node: Node2D in crop_nodes:
		if crop_node.global_position == local_cell_position:
			has_crop = true
	
	return has_crop


func remove_crop() -> void:
	if distance < minimun_crop_distance:
		var crop_nodes = get_parent().find_child("CropFields").get_children()
		
		for crop_node: Node2D in crop_nodes:
			if crop_node.global_position == local_cell_position:
				crop_node.queue_free()
