extends Area2D
class_name Projectile

@export var lifetime: float = 5

var damage: int
var speed: float
#var spread: float
var direction: Vector2 = Vector2.ZERO
var shooter : Node = null

func _ready() -> void:
	#connect("body_entered", _on_body_entered)
	#connect("area_entered", _on_area_entered)
	
	await get_tree().create_timer(lifetime).timeout
	if is_inside_tree():
		queue_free()

func fire(from: Node2D, base_dir: Vector2, proj_speed: float, proj_damage: int, proj_lifetime: float) -> void:
	shooter = from
	speed = proj_speed
	damage = proj_damage
	lifetime = proj_lifetime
	direction = base_dir.normalized()
	rotation = direction.angle()
	
	_start_lifetime_timer()

func _start_lifetime_timer() -> void:
	await get_tree().create_timer(lifetime).timeout
	if is_inside_tree():
		queue_free()

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		global_position += direction * speed * delta
	
	if not get_viewport_rect().grow(100).has_point(global_position):
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body == shooter:
		return
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
	
func _on_area_entered(area: Area2D) -> void:
	if area == shooter:
		return
	_deal_damage(area)

func _deal_damage(target: Node) -> void:
	if target.has_method("take_damage"):
		target.take_damage(damage)
	queue_free()
