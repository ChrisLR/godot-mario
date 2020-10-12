extends StaticBody2D

func on_bump(bumper):
	$AnimationPlayer.play("Break")
	$FragmentBL.visible = true
	$FragmentBR.visible = true
	$FragmentTL.visible = true
	$FragmentTR.visible = true


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Break":
		queue_free()
	
