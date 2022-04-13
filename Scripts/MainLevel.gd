extends Node2D


const chld_cnst = 2

var start_point = Vector2(0, 0)


func _ready():
	randomize()


func _process(delta):
	#update()
	pass


func _draw():
	# background draw
	var field_x = (gl.road_size_px + gl.room_width_px) * gl.rooms_column + gl.road_size_px
	var field_y = (gl.road_size_px + gl.room_height_px) * gl.rooms_line + gl.road_size_px
	draw_rect(Rect2(Vector2(0, 0), Vector2(field_x, field_y)), gl.background_color, true)
	
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
	
	var four_lines = [
		[Vector2(start_pos), Vector2(end_pos - Vector2(0, gl.room_height_px - th))], 
		[Vector2(end_pos - Vector2(0, gl.room_height_px - th)), Vector2(end_pos)], 
		[Vector2(end_pos), Vector2(start_pos + Vector2(0, gl.room_height_px - th))], 
		[Vector2(start_pos + Vector2(0, gl.room_height_px)), Vector2(start_pos)]
	]
	
	draw_line(start_pos - Vector2(th / 2, 0), end_pos - Vector2(0, gl.room_height_px - th), gl.room_color, gl.room_thickness)
	draw_line(end_pos - Vector2(0, gl.room_height_px - th) - Vector2(0, th / 2), end_pos, gl.room_color, gl.room_thickness)
	draw_line(end_pos + Vector2(th / 2, 0), start_pos + Vector2(0, gl.room_height_px - th), gl.room_color, gl.room_thickness)
	draw_line(start_pos + Vector2(0, gl.room_height_px - th) + Vector2(0, th / 2), start_pos, gl.room_color, gl.room_thickness)
	
	var cnt = room_count * 4 - 4
	for line in four_lines:
		var len_x = line[1][0] - line[0][0]
		var len_y = line[1][1] - line[0][1]
		var polygon_arr = [
			Vector2(-th / 2, -th / 2), 
			Vector2(th / 2 + len_x, -th / 2), 
			Vector2(th / 2 + len_x, th / 2 + len_y), 
			Vector2(-th / 2, th / 2 + len_y)
		]
		
		
		var polygon_test = [
			Vector2(-th / 2, -th / 2), 
			Vector2(th / 2, -th / 2), 
			Vector2(th / 2, th / 2), 
			Vector2(-th / 2, th / 2)
		]
		var th_pk = 32
		var polygon_test_2 = [
			Vector2(-th / th_pk, -th / th_pk), 
			Vector2(th / th_pk + len_x, -th / th_pk), 
			Vector2(th / th_pk + len_x, th / th_pk + len_y), 
			Vector2(-th / th_pk, th / th_pk + len_y)
		]
		#TODO разобраться багом левого нижнего угла
		
		
		# light shape
		var chld_light = LightOccluder2D.new()
		draw_light_shape(chld_light, polygon_arr, line)
		
		# wall
		var chld_wall = StaticBody2D.new()
		draw_wall(chld_wall, polygon_test_2, line)
		
		cnt += 1
		#TODO сделать генерацию дверей в комнатах

func draw_light_shape(chld, polygon_arr, line):
	add_child(chld)
	chld.occluder = load("res://Another/Testd.tres").duplicate(true)
	chld.occluder.polygon = polygon_arr
	chld.position = line[0]

func draw_wall(chld, polygon_arr, line):
	#print(polygon_arr)
	$".".add_child(chld)
	chld.add_child(CollisionPolygon2D.new())
	chld.get_child(0).polygon = polygon_arr
	chld.position = line[0]
