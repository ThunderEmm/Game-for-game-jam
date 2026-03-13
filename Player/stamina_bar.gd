extends Control
@onready var right_bar: ProgressBar = $right_bar
@onready var left_bar: ProgressBar = $left_bar
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_value() == 100 :
		if modulate.a == 1 :
			animation_player.play("staminabar_fade")
	else :
		animation_player.play("RESET")

func loss_stamina() :
	right_bar.value -= 0.4
	left_bar.value -= 0.4
	
func gain_stamina(Can_Sprint) :
	if Can_Sprint == true :
		right_bar.value += 0.1
		left_bar.value += 0.1
	elif Can_Sprint == false :
		right_bar.value += 0.15
		left_bar.value += 0.15
	
func get_value() :
	var value = right_bar.value + left_bar.value
	return value
	
