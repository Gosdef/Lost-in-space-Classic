extends Node2D


export (PackedScene) var bullet_scene


func _ready():
	pass


func _input(event):
	if event.is_action_pressed("Shoot") and gl.pl_bullet_clip_cnt > 0:
		gl.pl_bullet_clip_cnt -= 1
		var bullet = bullet_scene.instance()
		get_parent().get_parent().add_child(bullet)
		bullet.global_position = self.global_position
		bullet.direction = (get_global_mouse_position() - global_position).normalized()
		bullet.rotation = bullet.direction.angle()
