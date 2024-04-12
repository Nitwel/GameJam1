extends CanvasLayer

@onready var start_button = $ColorRect/CenterContainer/VBoxContainer/start
@onready var plus_button = $ColorRect/CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/plus
@onready var minus_button = $ColorRect/CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/minus
@onready var close_button = $ColorRect/CenterContainer/VBoxContainer/close
@onready var label = $ColorRect/CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/PanelContainer/Label
@onready var main = $/root/Main

const PlayerScene = preload ("./player.tscn")
var active_player = 0
var players = []

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(func():
		start()
		)
	
	plus_button.pressed.connect(func():
		label.text = str(max(int(label.text)-1, 2))
		)
	
	minus_button.pressed.connect(func():
		label.text = str(min(int(label.text)+1, 4))
		)

	close_button.pressed.connect(func():
		get_tree().quit()
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start():
	visible = false
	for i in range(int(label.text)):
		var player = PlayerScene.instantiate()
		players.append(player)
		main.add_child(player)
		player.global_position = Vector2(int(randf()* 1000),400)

		player.fired_bullet.connect(func(bullet):
			player.active=false

			bullet.tree_exited.connect(func():
				active_player=(active_player + 1) % int(label.text)
				update_active_player()
			)
		)

	update_active_player()


func update_active_player():
	for i in range(players.size()):
		players[i].active = (i == active_player)
