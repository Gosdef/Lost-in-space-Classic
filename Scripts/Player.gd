extends KinematicBody2D


var pl_pos = gl.pl_start_point
var speed = gl.pl_speed
var velocity = Vector2()


func _ready():
	pass


func _process(delta):
	update()
	$Camera2D.position = pl_pos
	$Light2D.position = pl_pos
	#$".".position = pl_pos


func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	pl_pos += velocity


func _draw():
	draw_circle(pl_pos, gl.pl_radius_px, gl.pl_color)
