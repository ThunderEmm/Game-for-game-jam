extends StaticBody3D

@onready var test_interact = $CollisionShape3D
@onready var outline_mesh =$CollisionShape3D/MeshInstance3D/outline

var highlighted = false
var outline_width = 0.05

func _ready() -> void:
	get_tree().get_first_node_in_group("Player").interact_object.connect(_set_selected)
	outline_mesh.visible = false
	
func _process(delta: float) -> void:
	outline_mesh.visible = highlighted
	if highlighted:
		test_interact.position.y = outline_width
	else:
		test_interact.position.y = 0
	
func _set_selected(object):
	highlighted = self == object
