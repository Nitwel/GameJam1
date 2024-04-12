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

@onready var on_floor1 = $OnFloor1
@onready var on_floor2 = $OnFloor2
@onready var arrow = $Arrow
@onready var arrow_image = $Arrow/ArrowImage
@onready var health_bar = $ProgressBar
@onready var shoot_timer = $ShootTimer
@export var active = false

func _ready():
	health = health

func _process(delta):

	var power = 1 - (shoot_timer.time_left / shoot_timer.wait_time)

	arrow_image.scale.y = lerp(0.01, 0.1, power)

	if Input.is_action_just_released("ui_fire") and active:
		var bullet = BulletScene.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = global_position
		bullet.apply_central_impulse(Vector2.UP.rotated(arrow.global_rotation) * 1000 * max(0.4, power))
		shoot_timer.stop()
		fired_bullet.emit(bullet)

	if Input.is_action_just_pressed("ui_fire") and active:
		shoot_timer.start()

	if active:
		var aim_direction = Input.get_axis("ui_up", "ui_down")

		arrow.rotation = clamp(arrow.rotation + aim_direction * 0.01, deg_to_rad( - 60), deg_to_rad(60))

func is_on_floor():
	return on_floor1.is_colliding() or on_floor2.is_colliding()

func _integrate_forces(state):

	if is_on_floor() and active:
		var direction = Vector2(Input.get_axis("ui_left", "ui_right"), 0).rotated(rotation)
		state.linear_velocity += direction * speed

	state.linear_velocity.clamp( - terminal_velocity, terminal_velocity)

func damage(amount):
	health -= amount

	if health <= 0:
		print("Player died")
		queue_free()
