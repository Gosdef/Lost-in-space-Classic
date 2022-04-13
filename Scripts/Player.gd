extends KinematicBody2D

var pl_pos = $".".position
var speed = gl.pl_speed
var rotation_speed = gl.pl_rotation_speed
var target = Vector2()
var velocity = Vector2()
var rotation_dir = 0
var move_click_turn = false
var move_key_cond = (
	Input.is_action_pressed("ui_right") or
	Input.is_action_pressed("ui_left") or
	Input.is_action_pressed("ui_up") or
	Input.is_action_pressed("ui_down")
)


func _ready():
	$".".position = gl.pl_start_point
	$Camera2D.limit_right = (gl.road_size_px + gl.room_width_px) * gl.rooms_column + gl.road_size_px
	$Camera2D.limit_bottom = (gl.road_size_px + gl.room_height_px) * gl.rooms_line + gl.road_size_px


func _process(delta):
	move_key_cond = (
	Input.is_action_pressed("ui_right") or
	Input.is_action_pressed("ui_left") or
	Input.is_action_pressed("ui_up") or
	Input.is_action_pressed("ui_down"))
	
	update()


func _input(event):
	if event.is_action_pressed("click"):
		move_click_turn = true
		target = get_global_mouse_position()


func _physics_process(delta):
	if (target - position).length() > 5 and move_click_turn and not move_key_cond:
		if abs($".".get_angle_to(target)) > 0.1:
			rotation_dir = $".".get_angle_to(target) / abs($".".get_angle_to(target))
			rotation += rotation_dir * rotation_speed * delta
		#if abs($".".get_angle_to(target)) < 0.1:
		get_input_click()
		move_and_slide(velocity)
	else:
		get_input_keys()
		rotation += rotation_dir * rotation_speed * delta
		move_and_slide(velocity)
		target = $".".position

func get_input_click():
	velocity = Vector2()
	velocity = (target - position).normalized() * speed

func get_input_keys():
	rotation_dir = 0
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		rotation_dir += 1
	if Input.is_action_pressed('ui_left'):
		rotation_dir -= 1
	if Input.is_action_pressed('ui_down'):
		velocity = Vector2(-speed, 0).rotated(rotation)
	if Input.is_action_pressed('ui_up'):
		velocity = Vector2(speed, 0).rotated(rotation)


func _draw():
	draw_circle(pl_pos, gl.pl_radius_px, gl.pl_color)
