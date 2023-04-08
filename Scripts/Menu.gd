extends Control

var mode : Mode
enum Mode {
	MAIN,
	OPTIONS,
	HIDDEN
}


# Called when the node enters the scene tree for the first time.
func _ready():
	setMode(Mode.HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		match mode:
			Mode.MAIN:
				setMode(Mode.HIDDEN)
			Mode.OPTIONS:
				setMode(Mode.MAIN)
			Mode.HIDDEN:
				setMode(Mode.MAIN)


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
		$ColorRect.visible = true
		visible = true


func hideAll():
	for child in get_children():
		child.visible = false




func _on_play_button_pressed():
	get_parent().play()


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


func _on_music_volume_value_changed(value):
	$"../Music".volume_db = value
