extends KinematicBody2D


var velocity = Vector2(0, 0)
var rotation_dir = 0
var speed = gl.en_normal_speed
var speed_run = gl.en_run_speed
var rotation_speed = gl.en_rotation_speed
var rn = RandomNumberGenerator.new()

var target


func _ready():
	rn.randomize()
	
	# Vision
	var shape = CircleShape2D.new()
	shape.radius = gl.en_detection_radius_px
	$Visibility/CollisionShape2D.shape = shape
	
	#Die circle
	var circle = CircleShape2D.new()
	circle.radius = gl.en_radius_px + 5
	$DieCircle/CollisionShape2D.shape = circle


func _physics_process(delta):
	update()
	if target:
		#watch()
		rotation = (target.position - position).angle()
		move_and_slide(Vector2((target.position - position).normalized() * speed_run))
	else:
		rotation += rotation_dir * rotation_speed * delta
		move_and_slide(velocity)

func _on_Timer_timeout():
	if not target:
		velocity = Vector2(speed, 0).rotated(rotation)
		rotation_dir = rn.randi_range(-1, 1)

func watch():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target.position, [self], collision_mask)
	
	if result:
		rotation = (target.position - position).angle()
		move_and_slide(Vector2((target.position - position).normalized() * speed_run))

func _draw():
	#draw_circle(Vector2(), gl.en_detection_radius_px, Color.green)
	pass


func _on_Visibility_body_entered(body):
	if target: 
		return
	if body.name == 'Player': 
		target = body

func _on_Visibility_body_exited(body):
	if body == target: target = null


func _on_DieCircle_body_entered(body):
	if body.name == 'Player':
		gl.pl_died = true
		get_tree().change_scene("res://Scenes/GameEnd.tscn")
