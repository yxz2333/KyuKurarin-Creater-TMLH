extends Control

@onready var conveyor_belt = $ConveyorBelt
@onready var back_ground = $BackGround
@onready var label = $Label
@onready var bgm_manager = $BgmManager

const COLORS = [Color(82/255.0,202/255.0,254/255.0), Color(254/255.0,255/255.0,148/255.0), Color(255/255.0,146/255.0,143/255.0), Color(250/255.0,181/255.0,81/255.0), Color(108/255.0,167/255.0,121/255.0)]
const NAMES = ["八奈见杏菜", "烧盐柠檬", "小鞠知花", "温水佳树", "温水和彦"]
const LABEL_COLORS = [Color(1,1,1),Color(0,0,0),Color(1,1,1),Color(1,1,1),Color(1,1,1)]
enum CH {
	八奈见杏菜,
	烧盐柠檬,
	小鞠知花,
	温水佳树,
	温水和彦
}
var now = 0 :  # 换人用 
	set(value):
		value %= len(CH)
		now = value
		conveyor_belt.switch_character(now)

func _ready():
	_init_label_background()
	_init_signals()

func _init_label_background():
	back_ground.color = COLORS[CH.八奈见杏菜]
	label.text = NAMES[CH.八奈见杏菜]
	label.label_settings.font_color = LABEL_COLORS[CH.八奈见杏菜]

func _init_signals():
	conveyor_belt.next_character.connect(_on_next_character)
	
func _on_next_character():
	now += 1                # 换人
	transition_animation()  # 过渡动画

func transition_animation():
	var tween = get_tree().create_tween() as Tween
	tween.tween_property(back_ground, "color" ,COLORS[now], 0.1).from_current()
	tween.set_parallel().tween_property(label, "text", NAMES[now], 0.1).from_current()
	tween.set_parallel().tween_property(label.label_settings, "font_color", LABEL_COLORS[now], 0.1).from_current()
	tween.play()
