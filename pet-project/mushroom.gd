extends CharacterBody2D

enum{
	IDLE,
	ATTACK,
	CHASE
}
var state: int = 0:
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()

@onready var animPlayer = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var direction


func _ready() -> void:
	Signals.connect("player_position_update", Callable(self, "_on_player_position_update"))


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if state == CHASE:
		chase_state()

	move_and_slide()


func _on_player_position_update(player_pos):
	player = player_pos


func _on_attack_range_body_entered(body: Node2D) -> void:
	state = ATTACK


func idle_state():
	animPlayer.play("idle")
	await get_tree().create_timer(1).timeout
	$AttackDirection/AttackRange/CollisionShape2D.disabled = false
	state = CHASE


func attack_state():
	animPlayer.play("attack")
	await animPlayer.animation_finished
	$AttackDirection/AttackRange/CollisionShape2D.disabled = true
	state = IDLE


func chase_state():
	direction = (player - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = true
		$AttackDirection.rotation_degrees = 180
	else:
		sprite.flip_h = false
		$AttackDirection.rotation_degrees = 0
