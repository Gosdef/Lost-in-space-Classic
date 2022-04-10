extends Node2D

var start_point = Vector2(0, 0)
export (PackedScene) var wall = load("res://Another/TEST.tscn")

func _ready():
	randomize()


func _process(delta):
	#update()
	pass


func _draw():
	# background draw
	draw_rect(Rect2(Vector2(0, 0), Vector2(2112, 1024)), gl.background_color, true)
	
	# room draw
	for x in range(gl.rooms_column):
		for y in range(gl.rooms_line):
			var rwp = gl.road_size_px
			var rwp_x = (gl.road_size_px + gl.room_width_px) * x + rwp
			var rwp_y = (gl.road_size_px + gl.room_height_px) * y + rwp
			var room_count = y + x * gl.rooms_line + 1
			draw_room(Vector2(rwp_x, rwp_y), Vector2(gl.room_width_px + rwp_x, gl.room_height_px + rwp_y), room_count)

func draw_room(start_pos, end_pos, room_count):
	var th = gl.room_thickness
	start_pos = start_pos + Vector2(th / 2, th / 2)
	end_pos = end_pos - Vector2(th / 2, th / 2)
	
	#var four_points = [
	#	Vector2(start_pos - Vector2(th / 2, 0)), 
	#	Vector2(end_pos - Vector2(0, gl.room_height_px - th) - Vector2(0, th / 2)), 
	#	Vector2(end_pos + Vector2(th / 2, 0)), 
	#	Vector2(start_pos + Vector2(0, gl.room_height_px - th) + Vector2(0, th / 2))
	#]
	
	var four_points = [
		Vector2(start_pos), 
		Vector2(end_pos - Vector2(0, gl.room_height_px - th)), 
		Vector2(end_pos), 
		Vector2(start_pos + Vector2(0, gl.room_height_px - th))
	]
	
	draw_line(start_pos - Vector2(th / 2, 0), end_pos - Vector2(0, gl.room_height_px - th), gl.room_color, gl.room_thickness)
	draw_line(end_pos - Vector2(0, gl.room_height_px - th) - Vector2(0, th / 2), end_pos, gl.room_color, gl.room_thickness)
	draw_line(end_pos + Vector2(th / 2, 0), start_pos + Vector2(0, gl.room_height_px - th), gl.room_color, gl.room_thickness)
	draw_line(start_pos + Vector2(0, gl.room_height_px - th) + Vector2(0, th / 2), start_pos, gl.room_color, gl.room_thickness)
	#TODO перейти с прорисовки лийний, на тайлы и таймап в целом
	
	var cnt = room_count * 4 - 4
	for point in four_points:
		var chld = wall.instance()
		add_child(chld)
		get_child(cnt + 7).position = point
		cnt += 1
		#TODO доделать генерацию комнат из тёмных дверей

func draw_obj_1():
	pass
