extends PanelContainer

class_name Card

signal down_finished(node : Card)

@onready var animation_player = $AnimationPlayer
@onready var texture_rect = $TextureRect

func call_finished_signal():
	down_finished.emit(self)

func down():
	animation_player.play("down")

func move():
	var tween = get_tree().create_tween() as Tween
	tween.tween_property(self,"position",Vector2(position.x - 100,position.y),0.04).from_current().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"position",Vector2(position.x - 80,position.y),0.04).from_current().set_ease(Tween.EASE_OUT)
	tween.play()

func set_texture(_texture : Texture2D):
	texture_rect.texture = _texture
