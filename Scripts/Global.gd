extends Node


# Карта
const road_size_px = 80
const background_color = Color.gray


# Комнаты 
const room_table = Vector2(15, 15)
const rooms_column = room_table[0]
const rooms_line = room_table[1]
const room_number = rooms_column * rooms_line

const room_thickness = 30.0
const room_color = Color.black
const room_height_px = 256
const room_width_px = 448

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
var pl_start_point = Vector2(2500, 2500)
var pl_vision_radius_px = 394
var pl_speed = 6 # pix?


# Состояние игры
var main_meny = true
var game_meny = false
var exposition_start = false
var storyline_start = false
var story_end = false
