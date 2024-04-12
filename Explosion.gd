extends Area2D
@onready var timer = $Timer
@onready var animation = $AnimatedSprite2D
@export var damage = 5
var hit =false


# Called when the node enters the scene tree for the first time.
func _ready():

	timer.timeout.connect(func():
		queue_free()
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var node2ds = get_overlapping_bodies()
	if hit:
		return
	for node in node2ds:
		if node is Player:
			node.damage(damage)
			hit = true
	
	
