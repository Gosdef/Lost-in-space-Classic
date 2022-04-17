extends StaticBody2D


export (PackedScene) var end


func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		print('Entered')
		$Before_end.start()

func _on_Before_end_timeout():
	get_tree().change_scene_to(end)
