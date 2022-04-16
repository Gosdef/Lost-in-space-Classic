extends StaticBody2D


export (PackedScene) var end

var cnt = 0


func _on_Area2D_body_entered(body):
	print('Entered')
	cnt += 1
	if cnt == 2:
		$Before_end.start()

func _on_Before_end_timeout():
	get_tree().change_scene_to(end)
