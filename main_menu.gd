extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Highscore_Score.text = str(Globals.highscore)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_start_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")



func _on_exit_pressed() -> void:
	# geht noch nicht
	get_tree().quit()
	
