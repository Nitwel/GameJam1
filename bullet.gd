extends RigidBody2D
@export var damage = 10
@onready var timer = $Timer
@onready var kill_timer = $KillTimer
@onready var collision = $CollisionShape2D

const ExplosionScene = preload ("./explosion.tscn")

func _ready():
	collision.disabled = true
	timer.timeout.connect(func():
		collision.disabled=false
	)

	kill_timer.timeout.connect(func():
		queue_free()
	)

func _physics_process(delta):
	var collisions = get_colliding_bodies()

	if collisions.size() > 0:
		var explosion = ExplosionScene.instantiate()
		get_parent().add_child(explosion)
		explosion.global_position = global_position
		queue_free()

	for coll in collisions:
		if coll is Player:
			coll.damage(damage)
