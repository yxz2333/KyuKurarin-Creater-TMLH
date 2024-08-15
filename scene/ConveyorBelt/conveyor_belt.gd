extends Control

signal next_character

@onready var button = %Button
@onready var cards_belt = $CardsBelt

const images = [
	[preload("res://resource/image/八奈见/nn8-1.png"), preload("res://resource/image/八奈见/n8-2.png"), preload("res://resource/image/八奈见/n8-3.png"), preload("res://resource/image/八奈见/n8-4.png"), preload("res://resource/image/八奈见/n8-5.png")],
	[preload("res://resource/image/烧盐/s-1.png"), preload("res://resource/image/烧盐/s-2.png"), preload("res://resource/image/烧盐/s-3.png")],
	[preload("res://resource/image/小鞠/j-1.png"), preload("res://resource/image/小鞠/j-2.png"), preload("res://resource/image/小鞠/j-3.png")],
	[preload("res://resource/image/温水佳树/树-1.png"), preload("res://resource/image/温水佳树/树-2-.png"), preload("res://resource/image/温水佳树/树-3.png")],
	[preload("res://resource/image/温水和彦/水-1.png"), preload("res://resource/image/温水和彦/水-2.png"), preload("res://resource/image/温水和彦/水-3.png")]
]
var card = preload("res://scene/Card/card.tscn")
var cards : Array[Card] = []
var who : int = 0
var max_row_num : int = 7  # 行中人物总数
var max_cnt : int = 4      # 行总数
var now : int = 0 : 
	set(value):
		value %= len(images[who])
		now = value
var cnt : int = 0 : 
	set(value):
		if value == max_cnt:
			next_character.emit()
			value = 0
		cnt = value
var sum : int = 0 :
	set(value):
		if value == max_row_num + 1: # 满人且用完空挡
			while cards:
				var now = cards.pop_back() as Card
				now.queue_free()
			value = 0
			cnt += 1
		sum = value


func _ready():
	button.pressed.connect(_on_button_pressed)

func switch_character(_who : int):
	who = _who

## 缓冲用变量
var button_press_cnt : int = 0 # 是否在CD时按下
var is_pressed : bool = false  # 是否CD
func _on_button_pressed():
	if is_pressed:
		button_press_cnt += 1
		return
	is_pressed = true
	now += 1
	create_card()

func create_card():
	var card_instance = card.instantiate()
	cards_belt.add_child(card_instance)
	if sum != max_row_num: # 放空档用
		card_instance.set_texture(images[who][now])
	_move()                # 所有card左移
	card_instance.down()   # 当前card下落
	card_instance.down_finished.connect(_on_down_finished) # 下落动画完毕的信号

func _move():
	for i in range(len(cards)):
		cards[i].move()

func _on_down_finished(card : Card):
	cards.append(card)
	sum += 1
	is_pressed = false
	
	if button_press_cnt:
		button_press_cnt = 0
		_on_button_pressed()
