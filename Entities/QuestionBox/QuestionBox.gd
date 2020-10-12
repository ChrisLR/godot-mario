extends StaticBody2D


export var Coins: int = 1

func on_bump(bumper):
	if Coins <= 0:
		return
	
	Coins -= 1
	bumper.add_coin(1)
	$AnimationPlayer.play("Hit")
	if Coins <= 0:
		$Block.play("Inactive")
