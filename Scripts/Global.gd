extends Node


# Карта
const road_size_px = 100
const background_color = Color.gray


# Комнаты 
var room_table = Vector2(15, 15) # changed in _ready
var rooms_column = room_table[0] # changed in _ready
var rooms_line = room_table[1] # changed in _ready
var room_number = rooms_column * rooms_line # changed in _ready
var room_win_room = 1 # changed in _ready

const room_thickness = 30.0
const room_color = Color.black
var room_height_px = 256 # changed in _ready
var room_width_px = 448 # changed in _ready
var room_door_px = 64 # changed in _ready

const room_type = ['common', 'toilet', 'server room']


# Враги
const en_radius_px = 16
const en_bos_radius_px = 32
const en_detection_radius_light_on_px = 250
const en_detection_radius_light_off_px = 150
var en_color = Color.blue
var en_normal_speed = 60 # pix?
var en_run_speed = 80 # pix?
var en_rotation_speed = 3 # pix?


# Игрок
const pl_radius_px = 16
var pl_color = Color.lightslategray
var pl_start_point = Vector2(road_size_px / 2, road_size_px / 2)
#var pl_vision_radius_px = 394
var pl_speed = 100 # pix?
var pl_rotation_speed = 3 # pix?
#var pl_turbo_balance_max = 100
#var pl_turbo_balance = pl_turbo_balance_max
#var pl_turbo_usage_speed = 10
var pl_died = false
var pl_light_on = true


# backup lighting
var bl_rotation_speed = 7 # pix?


# Состояние игры
var in_meny = true
var quiet = false
var zombi_hunting = false


var main_meny = true
#var game_meny = false
#var exposition_start = false
#var storyline_start = false
#var story_end = false
var room_visited = 0


func load_settings():
	in_meny = true
	quiet = false
	zombi_hunting = false
	
	var rn = RandomNumberGenerator.new()
	rn.randomize()
	
	#room_table = Vector2(rn.randi_range(4, 8), rn.randi_range(4, 8))
	room_table = Vector2(4, 3)
	#room_table = Vector2(1, 1)
	rooms_column = room_table[0]
	rooms_line = room_table[1]
	room_number = rooms_column * rooms_line
	room_win_room = rn.randi_range(2, room_number)
	if room_win_room <= room_number / 2:
		room_win_room = rn.randi_range(2, room_number)
	#room_win_room = 1
	print('tb ', room_table, ' ', room_win_room)
	
	
	room_height_px = rn.randi_range(5, 8) * 64
	room_width_px = rn.randi_range(5, 8) * 64
	print('hw ', Vector2(room_height_px, room_width_px))
	
	pl_died = false


func _ready():
	load_settings()
