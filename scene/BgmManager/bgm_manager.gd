extends Control

@onready var audio_stream_player = %AudioStreamPlayer
@onready var button = %Button
@onready var h_slider = %HSlider
const CONFIG_PATH = "user://config.ini"  # 保存音量用

func _ready():
	load_config()
	_init_h_slider()
	_init_signals()

func _init_h_slider():
	h_slider.value = get_volume()
	h_slider.value_changed.connect(_on_change_volume)
	h_slider.size = Vector2(0, 16)
	h_slider.hide()
	
func _init_signals():
	button.pressed.connect(_on_button_pressed)
	audio_stream_player.finished.connect(_on_audio_finished)

func get_volume() -> float:
	var db := AudioServer.get_bus_volume_db(0)
	return db_to_linear(db)

func set_volume(value : float):
	var db := linear_to_db(value)
	AudioServer.set_bus_volume_db(0, db)

func save_config():
	var config := ConfigFile.new()
	config.set_value("audio","master",get_volume())
	config.save(CONFIG_PATH)

func load_config():
	var config := ConfigFile.new()
	config.load(CONFIG_PATH)
	set_volume(config.get_value("audio","master",0.2))


func _on_change_volume(value : float):
	set_volume(value)
	save_config()

func _on_audio_finished():
	audio_stream_player.play()


func _on_button_pressed():
	button.disabled = true
	var tween = get_tree().create_tween() as Tween
	if h_slider.visible == false:
		tween.tween_property(h_slider,"size",Vector2(180,16),0.25).from_current().set_ease(Tween.EASE_IN_OUT)
		h_slider.show()
		tween.finished.connect(
			func(): 
				button.disabled = false
		)
	else:
		tween.tween_property(h_slider,"size",Vector2(0,16),0.25).from_current().set_ease(Tween.EASE_IN_OUT)
		tween.finished.connect(
		func():
			h_slider.hide()
			button.disabled = false
		)
	tween.play()

