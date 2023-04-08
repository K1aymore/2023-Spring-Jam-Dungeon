extends Control

var mode : Mode
enum Mode {
	MAIN,
	OPTIONS,
	HIDDEN,
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func setMode(newMode : Mode):
	hideAll()
	mode = newMode
	
	match mode:
		Mode.MAIN:
			$Main.visible = true
		Mode.OPTIONS:
			$Options.visible = true
			$Back.visible = true
		Mode.HIDDEN:
			visible = false
	
	if mode != Mode.HIDDEN:
		$TextureRect.visible = true
		visible = true


func hideAll():
	for child in get_children():
		child.visible = false




func _on_play_button_pressed():
	$"../Anim".play("menuHide")


func _on_options_button_pressed():
	setMode(Mode.OPTIONS)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_smooth_turning_toggled(button_pressed):
	get_parent().instantTurn = !button_pressed


func _on_smooth_movement_toggled(button_pressed):
	get_parent().instantMove = !button_pressed


func _on_back_pressed():
	setMode(Mode.MAIN)



func _on_vol_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
