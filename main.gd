extends Node2D

@onready var players = [$Player1, $Player2]
var active_player = 0

func _ready():
	update_active_player()
	for player in players:
		player.fired_bullet.connect(func(bullet):
			player.active=false

			bullet.tree_exited.connect(func():
				active_player=(active_player + 1) % players.size()
				update_active_player()
			)
		)

func update_active_player():
	for i in range(players.size()):
		players[i].active = (i == active_player)
