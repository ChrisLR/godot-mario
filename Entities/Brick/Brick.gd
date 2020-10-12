extends StaticBody2D

func on_bump(bumper):
	if not bumper.isSmall:
		$AnimationPlayer.play("Break")
		$FragmentBL.visible = true
		$FragmentBR.visible = true
		$FragmentTL.visible = true
		$FragmentTR.visible = true
	else:
		$AnimationPlayer.play("Hit")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Break":
		queue_free()
	
