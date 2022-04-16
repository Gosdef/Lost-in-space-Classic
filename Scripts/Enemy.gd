extends KinematicBody2D


var velocity = Vector2(0, 0)
var rotation_dir = 0
var speed = gl.en_normal_speed
var rotation_speed = gl.en_rotation_speed
var rn = RandomNumberGenerator.new()


func _ready():
	rn.randomize()


func _physics_process(delta):
	rotation += rotation_dir * rotation_speed * delta
	move_and_slide(velocity)

func _on_Timer_timeout():
	velocity = Vector2(speed, 0).rotated(rotation)
	rotation_dir = rn.randi_range(-1, 1)
