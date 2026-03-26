extends StaticBody3D

@onready var test_interact = $CollisionShape3D
@onready var outline_mesh = $MeshInstance3D/outline
@onready var switch = $"Switch Pivot"
@onready var light_group : StaticBody3D = $"../Large Light"
@onready var light : SpotLight3D = light_group.get_node("SpotLight3D")
@onready var light_glow_mesh : MeshInstance3D = light_group.get_node("MeshInstance3D2")
@onready var light_glow_mat : StandardMaterial3D = light_glow_mesh.get_active_material(0)

var highlighted = false
var outline_width = 0.05
var on = true

func _ready() -> void:
	# Delay connecting to player signal to avoid null errors
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.interact_object.connect(_set_selected)
	else:
		call_deferred("_connect_to_player")

	# Hide outline initially
	outline_mesh.visible = false


# Deferred function to connect after Player exists
func _connect_to_player():
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.interact_object.connect(_set_selected)
	
func _process(delta: float) -> void:
	outline_mesh.visible = highlighted
	if highlighted:
		test_interact.position.y = outline_width
		
		if Input.is_action_just_released("Interact"):
			if on:
				switch.rotation_degrees.z = 135
				light.visible = false
				light_glow_mat.emission_enabled = false
				on = false
			else:
				switch.rotation_degrees.z = 45
				light.visible = true
				light_glow_mat.emission_enabled = true
				on = true
	else:
		test_interact.position.y = 0
	
func _set_selected(object):
	highlighted = self == object
