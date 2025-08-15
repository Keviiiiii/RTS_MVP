extends CharacterBody2D

@export var speed := 40
@export var range := 1000
@export var contact_damage := 5
@export var attack_cooldown := 5

var attack_timer := 3
var health := 3
var target_building: Area2D = null

func _ready() -> void:
	add_to_group("enemies")
	if not $Hitbox.is_connected("body_entered", Callable(self, "_on_hitbox_body_entered")):
		$Hitbox.connect("body_entered", Callable(self, "_on_hitbox_body_entered"))
	if not $Hitbox.is_connected("area_entered", Callable(self, "_on_hitbox_area_entered")):
		$Hitbox.connect("area_entered", Callable(self, "_on_hitbox_area_entered"))

func _physics_process(delta: float) -> void:
	if attack_timer > 0:
		attack_timer -= delta
	
	# Find a target if none exists or it was destroyed
	if not target_building or not is_instance_valid(target_building):
		_find_closest_building()
	# Move toward target if we have one
	if target_building:
		var dist = global_position.distance_to(target_building.global_position)
		if dist > 10:
			var direction = (target_building.global_position - global_position).normalized()
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
			_attack_building(target_building)
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()

func _find_closest_building() -> void:
	var buildings = get_tree().get_nodes_in_group("buildings")
	var closest_dist := range
	var closest: Area2D = null
	for building in buildings:
		if not building is Area2D:
			continue
		if building.is_in_group("enemies"):
			continue
		var dist = global_position.distance_to(building.global_position)
		if dist < closest_dist:
			closest = building
			closest_dist = dist
	target_building = closest

func  _attack_building(building):
	if attack_timer <= 0 and building and building.is_in_group("buildings") and building.has_method("take_damage"):
		print("attacking")
		building.take_damage(contact_damage)
		attack_timer = attack_cooldown
		
func _on_hitbox_body_entered(body: Node2D) -> void:
	_attack_building(body)

func _on_hitbox_area_entered(area: Area2D) -> void:
	_attack_building(area)
