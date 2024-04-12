extends RigidBody2D
class_name Player

const BulletScene = preload ("./bullet.tscn")

signal fired_bullet(bullet: Node2D)

@export var terminal_velocity = Vector2(400, 1000)
@export var speed = 40.0
@export var health = 40:
	set(value):
		health = value

		if !is_inside_tree():
			return

		health_bar.value = health

@onready var arrow = $Arrow
@onready var arrow_image = $Arrow/ArrowImage
@onready var health_bar = $ProgressBar
@onready var shoot_timer = $ShootTimer
@onready var players = $/root/Main/Players
@onready var main = $/root/Main
@onready var menu = $/root/Main/menu
@export var active = false


var charging = false

func _ready():
	health = health

func _process(delta):

	var power = 1 - (shoot_timer.time_left / shoot_timer.wait_time)

	arrow_image.scale.y = lerp(0.01, 0.1, power)

	if Input.is_action_just_released("ui_fire") and active and charging:
		var bullet = BulletScene.instantiate()
		main.add_child(bullet)
		bullet.global_position = global_position
		bullet.apply_central_impulse(Vector2.UP.rotated(arrow.global_rotation) * 1000 * max(0.4, power))
		shoot_timer.stop()
		fired_bullet.emit(bullet)
		charging = false

	if Input.is_action_just_pressed("ui_fire") and active:
		shoot_timer.start()
		charging = true

	if active:
		var aim_direction = Input.get_axis("tilt_left", "tilt_right")

		arrow.rotation = clamp(arrow.rotation + aim_direction * 0.01, deg_to_rad( - 60), deg_to_rad(60))

func _integrate_forces(state):

	if test_move(transform, Vector2(0, 1)) and active:
		var direction = Vector2(Input.get_axis("move_left", "move_right"), 0).rotated(rotation)
		state.linear_velocity += direction * speed

	state.linear_velocity.clamp( - terminal_velocity, terminal_velocity)

func damage(amount):
	health -= amount

	if health <= 0:
		print("Player died")
		print(players.get_child_count())
		if players.get_child_count() < 3:
			for player in players.get_children():
				print(player)
				player.queue_free()
			menu.visible = true
		else:
			queue_free()
