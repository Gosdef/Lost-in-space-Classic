extends Node


# Карта
const passage_width_pix = 64


# Враги
const enemy_radius_pix = 32
const enemy_bos_radius_pix = 50
const enemy_detection_radius_pix = 320


# Комнаты 
const room_number = 10
var room_height_pix = 256
var room_width_pix = 448
#TODO настароить автоматическую генерацию локаций по заданным параметрам и описать эти параметры)


# Игрок
const player_radius_pix = 32
var speed = 50 # pix?


# Состояние игры
var main_meny = true
var game_meny = false
var exposition_start = false
var storyline_start = false
var story_end = false
