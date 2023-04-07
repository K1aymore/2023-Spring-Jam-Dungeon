extends Control


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
	pass


func setMode(mode : Mode):
	hideAll()
	
	match mode:
		Mode.MAIN:
			$Main.visible = true
		Mode.OPTIONS:
			$Options.visible = true
			$Back.visible = true
	
	if mode != Mode.HIDDEN:
		$ColorRect.visible = true


func hideAll():
	for child in get_children():
		child.visible = false




func _on_play_button_pressed():
	setMode(Mode.HIDDEN)
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
