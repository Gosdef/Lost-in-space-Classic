extends Node2D


export (PackedScene) var enemy 
export (PackedScene) var backup_light
export (PackedScene) var escape_capsule
export (PackedScene) var siren

const chld_cnst = 2

var start_point = Vector2(0, 0)
var rn = RandomNumberGenerator.new()
var copy = gl.zombi_hunting


func _ready():
	rn.randomize()
	$Quiet.play()


func _process(delta):
	#update()
	
	if gl.zombi_hunting != copy and gl.zombi_hunting == true:
		copy = gl.zombi_hunting
		$Quiet.stop()
		#$Zombi.play()
	elif gl.zombi_hunting != copy and gl.zombi_hunting == false:
		copy = gl.zombi_hunting
		$Quiet.play()
		#$Zombi.stop()


func _draw():
	# background draw
	var field_x = (gl.road_size_px + gl.room_width_px) * gl.rooms_column + gl.road_size_px
	var field_y = (gl.road_size_px + gl.room_height_px) * gl.rooms_line + gl.road_size_px
	draw_rect(Rect2(Vector2(-gl.room_thickness, -gl.room_thickness), Vector2(field_x + 2 * gl.room_thickness, field_y + 2 * gl.room_thickness)), gl.background_color, true)
	
	
	# surrounding wall
	var th = gl.room_thickness
	var map_height = (gl.road_size_px + gl.room_height_px) * gl.rooms_line + gl.road_size_px
	var map_width = (gl.road_size_px + gl.room_width_px) * gl.rooms_column + gl.road_size_px
	var start_pos = -Vector2(th / 2, th / 2)
	var end_pos = Vector2(map_width, map_height) + Vector2(th / 2, th / 2)
	var four_lines = [
		[Vector2(start_pos), Vector2(end_pos - Vector2(0, map_height + th))], 
		[Vector2(end_pos - Vector2(0, map_height + th)), Vector2(end_pos)], 
		[Vector2(end_pos), Vector2(start_pos + Vector2(0, map_height + th))], 
		[Vector2(start_pos + Vector2(0, map_height + th)), Vector2(start_pos)]]
	for line in four_lines:
		var len_x = line[1][0] - line[0][0]
		var len_y = line[1][1] - line[0][1]
		var polygon_arr = [
			Vector2(-th / 2, -th / 2), 
			Vector2(th / 2 + len_x, -th / 2), 
			Vector2(th / 2 + len_x, th / 2 + len_y), 
			Vector2(-th / 2, th / 2 + len_y)]
		# surrounding light shape
		var chld_light = LightOccluder2D.new()
		draw_light_shape(chld_light, polygon_arr, line[0])
		# surrounding wall
		var chld_wall = StaticBody2D.new()
		draw_wall(chld_wall, polygon_arr, line[0])
	
	
	# room draw
	for x in range(gl.rooms_column):
		for y in range(gl.rooms_line):
			var rwp = gl.road_size_px
			var rwp_x = (gl.road_size_px + gl.room_width_px) * x + rwp
			var rwp_y = (gl.road_size_px + gl.room_height_px) * y + rwp
			var room_count = y + x * gl.rooms_line + 1
			draw_room(Vector2(rwp_x, rwp_y), Vector2(gl.room_width_px + rwp_x, gl.room_height_px + rwp_y), room_count)

func draw_room(start_position, end_position, room_count):
	var win_room_cond = (room_count == gl.room_win_room)
	var th = gl.room_thickness
	var start_pos = start_position + Vector2(th / 2, th / 2)
	var end_pos = end_position - Vector2(th / 2, th / 2)
	
	var spawn_door = rn.randi_range(0, 3)
	var spawn_zombi = rn.randi_range(0, 9)
	
	# enemy generator
	var zmbi_cnt = rn.randi_range(2, 5)
	var zombi_cond = (spawn_zombi <= 3)
	var enemy_room = false
	if (zombi_cond or win_room_cond) and room_count != 1:
		for i in range(zmbi_cnt):
			var enemy_in_room = enemy.instance()
			add_child(enemy_in_room)
			enemy_in_room.position = end_pos - Vector2(gl.room_width_px / 2 + i * 10, gl.room_height_px / 2 + i * 10)
	
	# door generator
	gl.room_door_px = rn.randi_range(3, 4) * 32
	if zombi_cond and not win_room_cond: gl.room_door_px = 5 * 32
	var lines = [
		[Vector2(start_pos), Vector2(end_pos - Vector2(0, gl.room_height_px - th))], 
		[Vector2(end_pos - Vector2(0, gl.room_height_px - th)), Vector2(end_pos)], 
		[Vector2(end_pos), Vector2(start_pos + Vector2(0, gl.room_height_px - th))], 
		[Vector2(start_pos + Vector2(0, gl.room_height_px)), Vector2(start_pos)]]
	if zombi_cond and not win_room_cond:
		lines[0] = [Vector2(start_pos), Vector2(end_pos - Vector2((gl.room_width_px + gl.room_door_px - th) / 2, gl.room_height_px - th))]
		lines[1] = [Vector2(end_pos - Vector2(0, gl.room_height_px - th)), Vector2(end_pos) - Vector2(0, (gl.room_height_px + gl.room_door_px - th) / 2)]
		lines[2] = [Vector2(end_pos), Vector2(start_pos + Vector2((gl.room_width_px + gl.room_door_px - th) / 2, gl.room_height_px - th))]
		lines[3] = [Vector2(start_pos + Vector2(0, gl.room_height_px)), Vector2(start_pos) + Vector2(0, (gl.room_height_px + gl.room_door_px - th) / 2)]
		lines.append([Vector2(end_pos - Vector2((gl.room_width_px - gl.room_door_px - th) / 2, gl.room_height_px - th)), Vector2(end_pos - Vector2(0, gl.room_height_px - th))])
		lines.append([Vector2(end_pos) - Vector2(0, (gl.room_height_px - gl.room_door_px - th) / 2), Vector2(end_pos)])
		lines.append([Vector2(start_pos + Vector2((gl.room_width_px - gl.room_door_px - th) / 2, gl.room_height_px - th)), Vector2(start_pos + Vector2(0, gl.room_height_px - th))])
		lines.append([Vector2(start_pos) + Vector2(0, (gl.room_height_px - gl.room_door_px - th) / 2), Vector2(start_pos)])
	elif spawn_door == 0:
		lines[0] = [Vector2(start_pos), Vector2(end_pos - Vector2((gl.room_width_px + gl.room_door_px - th) / 2, gl.room_height_px - th))]
		lines.append([Vector2(end_pos - Vector2((gl.room_width_px - gl.room_door_px - th) / 2, gl.room_height_px - th)), Vector2(end_pos - Vector2(0, gl.room_height_px - th))])
	elif spawn_door == 1:
		lines[1] = [Vector2(end_pos - Vector2(0, gl.room_height_px - th)), Vector2(end_pos) - Vector2(0, (gl.room_height_px + gl.room_door_px - th) / 2)]
		lines.append([Vector2(end_pos) - Vector2(0, (gl.room_height_px - gl.room_door_px - th) / 2), Vector2(end_pos)])
	elif spawn_door == 2:
		lines[2] = [Vector2(end_pos), Vector2(start_pos + Vector2((gl.room_width_px + gl.room_door_px - th) / 2, gl.room_height_px - th))] 
		lines.append([Vector2(start_pos + Vector2((gl.room_width_px - gl.room_door_px - th) / 2, gl.room_height_px - th)), Vector2(start_pos + Vector2(0, gl.room_height_px - th))])
	elif spawn_door == 3:
		lines[3] = [Vector2(start_pos + Vector2(0, gl.room_height_px)), Vector2(start_pos) + Vector2(0, (gl.room_height_px + gl.room_door_px - th) / 2)]
		lines.append([Vector2(start_pos) + Vector2(0, (gl.room_height_px - gl.room_door_px - th) / 2), Vector2(start_pos)])
	
	# backup light
	if zombi_cond and not win_room_cond and room_count != 1:
		var backup_light_in_room = backup_light.instance()
		add_child(backup_light_in_room)
		backup_light_in_room.position = start_position + Vector2(th + 5, th + 5)
	
	# win room
	if win_room_cond:
		var capsule = escape_capsule.instance()
		add_child(capsule)
		capsule.position = end_pos - Vector2(gl.room_width_px / 2, gl.room_height_px / 2)
	
	
	# for debug
	draw_line(start_pos - Vector2(th / 2, 0), end_pos - Vector2(0, gl.room_height_px - th), gl.room_color, gl.room_thickness)
	draw_line(end_pos - Vector2(0, gl.room_height_px - th) - Vector2(0, th / 2), end_pos, gl.room_color, gl.room_thickness)
	draw_line(end_pos + Vector2(th / 2, 0), start_pos + Vector2(0, gl.room_height_px - th), gl.room_color, gl.room_thickness)
	draw_line(start_pos + Vector2(0, gl.room_height_px - th) + Vector2(0, th / 2), start_pos, gl.room_color, gl.room_thickness)
	
	
	var cnt = room_count * 4 - 4
	for i in range(len(lines)):
		var line = lines[i]
		var len_x = line[1][0] - line[0][0]
		var len_y = line[1][1] - line[0][1]
		var polygon_arr = [
			Vector2(-th / 2, -th / 2), 
			Vector2(th / 2 + len_x, -th / 2), 
			Vector2(th / 2 + len_x, th / 2 + len_y), 
			Vector2(-th / 2, th / 2 + len_y)
		]
		
		
		# light shape
		var chld_light = LightOccluder2D.new()
		draw_light_shape(chld_light, polygon_arr, line[0])
		
		# wall
		var chld_wall = StaticBody2D.new()
		draw_wall(chld_wall, polygon_arr, line[0])
		
		cnt += 1

func draw_light_shape(chld, polygon, lin0):
	add_child(chld)
	chld.occluder = load("res://Another/Testd.tres").duplicate(true)
	chld.occluder.polygon = polygon
	chld.position = lin0

func draw_wall(chld, polygon, lin0):
	#print(polygon_arr)
	$".".add_child(chld)
	chld.add_child(CollisionPolygon2D.new())
	chld.get_child(0).polygon = polygon
	chld.position = lin0
