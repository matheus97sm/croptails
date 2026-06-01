extends Panel

@onready var animated_sprite_2d: AnimatedSprite2D = $Emote/AnimatedSprite2D
@onready var emote_idle_timer: Timer = $EmoteIdleTimer

const EMOTE_IDLE_PREFIX = "emote_idle"

var idle_emotes: Array[String]

func _ready() -> void:
	play_emote(EMOTE_IDLE_PREFIX)
	
	var emote_names = animated_sprite_2d.sprite_frames.get_animation_names()
	
	for emote_name in emote_names:
		if emote_name.begins_with("emote_idle"):
			idle_emotes.append(emote_name)


func play_emote(animation: String) -> void:
	animated_sprite_2d.play(animation)


func _on_emote_idle_timer_timeout() -> void:
	var index = randi_range(0, idle_emotes.size() - 1)
	var emote = idle_emotes[index]
	
	play_emote(emote)
