extends KinematicBody2D


var pl_pos = $".".position
var speed = gl.pl_speed
#var rotation_speed = gl.pl_rotation_speed
var target = Vector2()
var velocity = Vector2()
var rotation_dir = 0
var move_click_turn = false
var move_key_cond = (
	Input.is_action_pressed("ui_right") or
	Input.is_action_pressed("ui_left") or
	Input.is_action_pressed("ui_up") or
	Input.is_action_pressed("ui_down"))
#TODO добавить игроку пистолет и 5 патронк нему


func _ready():
	$".".position = gl.pl_start_point
	$Camera2D.limit_left = -gl.room_thickness
	$Camera2D.limit_top = -gl.room_thickness
	$Camera2D.limit_right = (gl.road_size_px + gl.room_width_px) * gl.rooms_column + gl.road_size_px + gl.room_thickness
	$Camera2D.limit_bottom = (gl.road_size_px + gl.room_height_px) * gl.rooms_line + gl.road_size_px + gl.room_thickness
	#TODO зависимость колизии от размера игрока)))


func _process(delta):
	speed = gl.pl_speed
	#rotation_speed = gl.pl_rotation_speed
	move_key_cond = (
	Input.is_action_pressed("ui_right") or
	Input.is_action_pressed("ui_left") or
	Input.is_action_pressed("ui_up") or
	Input.is_action_pressed("ui_down"))
	
	update()


func _input(event):
	#if event.is_action_pressed("click"):
	#	move_click_turn = true
	#	target = get_global_mouse_position()
	
	if event.is_action_pressed("Light_switch"):
		gl.pl_light_on = not $StrongLight.enabled
		$StrongLight.enabled = not $StrongLight.enabled
	
	if event.is_action_pressed("Radar") and gl.pl_radar_on_cooldown == false and gl.pl_radar_count > 0:
		gl.pl_radar_count -= 1
		gl.pl_radar_on = true
		gl.pl_radar_on_cooldown = true
		$Timer_radar.start()
		$Timer_radar_cooldown.start()


func _physics_process(delta):
	if (target - position).length() > 5 and move_click_turn and not move_key_cond:
		if abs($".".get_angle_to(target)) > 0.1:
			rotation_dir = $".".get_angle_to(target) / abs($".".get_angle_to(target))
			#rotation += rotation_dir * rotation_speed * delta
		if abs($".".get_angle_to(target)) < 0.1:
			get_input_click()
			move_and_slide(velocity)
	else:
		get_input_keys()
		look_at(get_global_mouse_position())
		#rotation += rotation_dir * rotation_speed * delta
		move_and_slide(velocity)
		target = $".".position

func get_input_click():
	#velocity = Vector2()
	#velocity = (target - position).normalized() * speed
	#if Input.is_action_pressed("Turbo"):
	#	velocity *= 1.5
	pass

func get_input_keys():
	rotation_dir = 0
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	#if Input.is_action_pressed("Turbo") and gl.pl_turbo_balance > 0 and move_key_cond:
		#gl.pl_turbo_balance -= gl.pl_turbo_usage_speed
		#velocity += Vector2(speed / 2, 0).rotated(rotation)
		#$Tb_recovering_timer.wait_time = 2
		#$Tb_recovering_timer.start()

func _on_Tb_time_after_use_timeout():
	$Tb_time_after_use.autostart = true

func _on_Tb_recovering_timer_timeout():
	if gl.pl_turbo_balance_max != gl.pl_turbo_balance:
		gl.pl_turbo_balance += gl.pl_turbo_usage_speed


func _on_Timer_radar_timeout():
	gl.pl_radar_on = false

func _on_Timer_radar_cooldown_timeout():
	gl.pl_radar_on_cooldown = false
