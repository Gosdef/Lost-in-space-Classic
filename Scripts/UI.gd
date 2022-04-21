extends Control

var copy_ammo = gl.pl_bullet_global_cnt
var copy_clip = gl.pl_bullet_clip_cnt
var copy_turbo = gl.pl_turbo_balance
var copy_radar = gl.pl_radar_on
var radar_cooldown = 8 #TODO синхронизировать с global script


func _ready():
	$Ammo.text = 'Кол-во патрон ' + str(gl.pl_bullet_global_cnt)
	$Ammo/Clip.text = 'Обойма ' + str(gl.pl_bullet_clip_cnt) + ' из ' + str(gl.pl_bullet_clip_max)
	$Radar.text = "Радар выключён"
	$Radar/Count.text = "Кол-во = " + str(gl.pl_radar_count)
	$Turbo.text = "Заряд Turbo = %s" % gl.pl_turbo_balance

func _process(delta):
	if copy_ammo != gl.pl_bullet_global_cnt or copy_clip != gl.pl_bullet_clip_cnt:
		copy_clip = gl.pl_bullet_clip_cnt
		copy_ammo = gl.pl_bullet_global_cnt
		$Ammo/Clip.text = 'Обойма ' + str(gl.pl_bullet_clip_cnt) + ' из ' + str(gl.pl_bullet_clip_max)
		$Ammo.text = 'Кол-во патрон ' + str(gl.pl_bullet_global_cnt)
	
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
