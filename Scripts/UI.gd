extends Control

var copy_light = gl.pl_light_on
var copy_turbo = gl.pl_turbo_balance
var copy_radar = gl.pl_radar_on
var radar_cooldown = 8 #TODO синхронизировать с global script


func _ready():
	$Light.text = "Фонарик включён"
	$Radar.text = "Радар выключён"
	$Radar/Count.text = "Кол-во = " + str(gl.pl_radar_count)
	$Turbo.text = "Заряд Turbo = %s" % gl.pl_turbo_balance

func _process(delta):
	if copy_light != gl.pl_light_on:
		copy_light = gl.pl_light_on
		if gl.pl_light_on:
			$Light.text = "Фонарик включён"
		else:
			$Light.text = "Фонарик выключён"
	
	if copy_radar != gl.pl_radar_on or gl.pl_radar_on_cooldown == false:
		copy_radar = gl.pl_radar_on
		if gl.pl_radar_on:
			$Radar.text = "Радар включён"
			$Radar/Count.text = "Кол-во = " + str(gl.pl_radar_count)
		else:
			#radar_cooldown = 8 #TODO синхронизировать с global script
			#$Radar/Timer.start()
			if gl.pl_radar_on_cooldown:
				$Radar.text = "Радар перезаряжается"
			else:
				$Radar.text = "Радар готов"
	
	if copy_turbo != gl.pl_turbo_balance:
		copy_turbo = gl.pl_turbo_balance
		$Turbo.text = "Заряд Turbo = %s" % gl.pl_turbo_balance


#func _on_Timer_timeout():
#	if radar_cooldown >= 0:
#		$Radar.text = "Перезарядка: " + str(radar_cooldown)
#		radar_cooldown -= 1
#	else:
#		$Radar.text = "Радар выключён"
