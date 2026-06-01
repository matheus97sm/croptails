extends PanelContainer

@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
@onready var tool_tilling: Button = $MarginContainer/HBoxContainer/ToolTilling
@onready var tool_watering_can: Button = $MarginContainer/HBoxContainer/ToolWateringCan
@onready var tool_corn: Button = $MarginContainer/HBoxContainer/ToolCorn
@onready var tool_tomato: Button = $MarginContainer/HBoxContainer/ToolTomato

var initial_disabled_buttons: Array[Button] = [tool_tilling, tool_watering_can, tool_corn, tool_tomato]

@onready var tool_buttons = [
	tool_axe,
	tool_tilling,
	tool_watering_can,
	tool_corn,
	tool_tomato
]


func _ready() -> void:
	ToolManager.enable_tool.connect(on_enable_tool_button)
	
	for button in initial_disabled_buttons:
		button.disabled = true
		button.focus_mode = Control.FOCUS_NONE


func _on_tool_axe_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.AxeWood)
	tool_axe.grab_focus()


func _on_tool_tilling_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.TillGround)
	tool_tilling.grab_focus()


func _on_tool_watering_can_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.WaterCrops)
	tool_watering_can.grab_focus()


func _on_tool_corn_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.PlantCorn)
	tool_corn.grab_focus()


func _on_tool_tomato_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.PlantTomato)
	tool_tomato.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("release_tool"):
		ToolManager.select_tool(DataTypes.Tools.None)
		for tool_button in tool_buttons:
			tool_button.release_focus()


func on_enable_tool_button(tool: DataTypes.Tools) -> void:
	pass
	#for button in initial_disabled_buttons:
		#if button.tool
