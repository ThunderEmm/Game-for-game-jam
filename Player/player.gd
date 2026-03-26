extends CharacterBody3D
@onready var player_camera: Camera3D = $Player_Camera	
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var stamina_bar: Control = $player_ui/Stamina_bar
@onready var flashlight: SpotLight3D = $Flashlight
@onready var crosshair: ColorRect = $player_ui/crosshair
@onready var ray_cast_3d: RayCast3D = $Player_Camera/RayCast3D

@export var SPEED = 200.0
@export var Sprint_SPEED = 300.0
@export var JUMP_VELOCITY = 4.5
@export var Sensitivity : float = 0.001
@onready var Crouch_progress = 0   
@onready var Stamina = 100   
@onready var Can_Sprint = true   
@onready var Can_Rotate_Camera = true   
@onready var object_on_mark
signal interact_object

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		interact_object.emit(collider)
	else:
		interact_object.emit(null)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		# if Input.is_action_pressed("Sprint") and SPEED != 75 and Can_Sprint == true :
		# 	velocity.x = direction.x * Sprint_SPEED * delta
		# 	velocity.z = direction.z * Sprint_SPEED * delta
		# 	stamina_bar.loss_stamina() 
		# else :
			velocity.x = direction.x * SPEED * delta
			velocity.z = direction.z * SPEED * delta
			# stamina_bar.gain_stamina(Can_Sprint)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		# stamina_bar.gain_stamina(Can_Sprint)

	move_and_slide()
	# Crouch(delta)
	# Stamina_Control(delta)
	# Use_Flashlight()
	Change_Cross_hair() 
	set_Object_om_mark()
	
func check_move_backward() :
	if Input.is_action_pressed("ui_down") :
		print("ahh")
		SPEED = 175
	else :
		SPEED = 200
	
func set_Object_om_mark() :
	if ray_cast_3d.get_collider() is Area3D :
		object_on_mark = ray_cast_3d.get_collider()
	else :
		object_on_mark = null
	
func Change_Cross_hair() :
	if object_on_mark != null :
		crosshair.color.b = 0
		crosshair.color.a = 1
	else :
		crosshair.color.b = 255
		crosshair.color.a = 0.3
		
func Use_Flashlight() :
	# if Input.is_action_just_pressed("Flashlight") :
	# 	flashlight.visible = !flashlight.visible
	pass
	
func Stamina_Control(_delta) :
	# Stamina = stamina_bar.get_value()
	# if Stamina == 0 :
	# 	Can_Sprint = false
	# if Stamina == 100 :
	# 	Can_Sprint = true
	pass
	
func Crouch(delta):
	# if Input.is_action_pressed("Crouch"):
	# 	Crouch_progress += 3 * delta
	# 	SPEED = 75
	# else :
	# 	Crouch_progress -= 5 * delta
	# 	SPEED = 200
	# Crouch_progress = clamp(Crouch_progress, 0, 1) 
	# animation_tree.set("parameters/Blend2/blend_amount", Crouch_progress)
	pass

func _input(event):
	if event is InputEventMouseMotion and Can_Rotate_Camera == true :
		rotate_y(-event.relative.x * Sensitivity)
		player_camera.rotate_x(-event.relative.y *Sensitivity)
		player_camera.rotation.x = clamp(player_camera.rotation.x, -PI/2, PI/2)
		flashlight.rotate_x(-event.relative.y *Sensitivity)
		flashlight.rotation.x = clamp(player_camera.rotation.x, -PI/2, PI/2)
		fixCameraRotate()

func fixCameraRotate():
	if player_camera.rotation_degrees.x <= -65:
		player_camera.rotation_degrees.x = -65
		flashlight.rotation_degrees.x = -65
	if player_camera.rotation_degrees.x >= 77:
		player_camera.rotation_degrees.x = 77
		flashlight.rotation_degrees.x = 77
