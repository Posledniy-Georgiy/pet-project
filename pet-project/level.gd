extends Node2D

@onready var light = $DirectionalLight2D
@onready var pointLight = $PointLight2D
@onready var day_text = $CanvasLayer/DayText
@onready var animPlayer = $CanvasLayer/AnimationPlayer

enum{
	MORNING,
	DAY,
	EVENING,
	NIGHT
}


var state = MORNING
var day_count: int

func _ready() -> void:
	light.enabled = true
	day_count = 1
	set_day_text()
	day_text_fade()


func morning_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.2, 20)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(pointLight, "energy", 0, 20)


func evening_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.95, 20)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(pointLight, "energy", 1.5, 20)


func _on_day_night_timeout() -> void:
	match state:
		MORNING:
			morning_state()
		EVENING:
			evening_state()
	if state < 3:
		state += 1
	else:
		state = MORNING
		day_count += 1
		set_day_text()
		day_text_fade()


func day_text_fade():
	animPlayer.play("day_text_fade_in")
	await get_tree().create_timer(3).timeout
	animPlayer.play("day_text_fade_out")


func set_day_text():
	day_text.text = "DAY - " + str(day_count)
