extends Area2D

@export var speed := 40
@export var damage := 1

var velocity := Vector2.ZERO
var direction := Vector2.ZERO

func _ready() -> void:
	set_deferred("monitoring", true)
	connect("body_entered", _on_body_entered)
	connect("area_entered", _on_area_entered)
	
func _process(delta: float) -> void:
	position += velocity * speed * delta

func _deal_damage(target: Node) -> void:
	if target.has_method("take_damage"):
		target.take_damage(damage)

func _on_body_entered(body: Node2D) -> void:
	_deal_damage(body)

func _on_area_entered(area: Area2D) -> void:
	_deal_damage(area)

func _check_and_damage(target):
	if target.is_in_group("enemies") and target.has_method("take_damage"):
		target.take_damage(damage)
		queue_free()
