extends Node


# Карта
const road_size_px = 100
const background_color = Color.gray


# Комнаты 
var room_table = Vector2(15, 15) # changed in _ready
var rooms_column = room_table[0] # changed in _ready
var rooms_line = room_table[1] # changed in _ready
var room_number = rooms_column * rooms_line # changed in _ready

const room_thickness = 30.0
const room_color = Color.black
var room_height_px = 256 # changed in _ready
var room_width_px = 448 # changed in _ready

const room_type = ['common', 'toilet', 'server room']


# Враги
const en_radius_px = 16
const en_bos_radius_px = 32
const en_detection_radius_px = 192
var en_color = Color.blue
var en_normal_speed = 30 # pix?
var en_run_speed = 70 # pix?
 

# Игрок
const pl_radius_px = 16
var pl_color = Color.black
var pl_start_point = Vector2(road_size_px / 2, road_size_px / 2)
#var pl_vision_radius_px = 394
var pl_speed = 150 # pix?
var pl_rotation_speed = 3 # pix?


# Состояние игры
var main_meny = true
var game_meny = false
var exposition_start = false
var storyline_start = false
var story_end = false
var room_visited = 0


func _ready():
	var rn = RandomNumberGenerator.new()
	rn.randomize()
	
	room_table = Vector2(rn.randi_range(4, 12), rn.randi_range(4, 12))
	#room_table = Vector2(1, 1)
	rooms_column = room_table[0]
	rooms_line = room_table[1]
	room_number = rooms_column * rooms_line
	print('tb ', room_table)
	
	room_height_px = rn.randi_range(4, 8) * 64
	room_width_px = rn.randi_range(4, 8) * 64
	print('hw ', Vector2(room_height_px, room_width_px))
