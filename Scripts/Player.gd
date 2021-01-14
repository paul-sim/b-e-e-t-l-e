extends KinematicBody2D

const ACCELERATION = 2000 #500
const MAX_SPEED = 80
const FRICTION = 2000 #700

var velocity = Vector2.ZERO
var velocityJump = Vector2.ZERO

var last_run_direction = ConstantsEnums.DIRECTION.NEUTRAL

onready var Player_animationPlayer = $Player_AnimationPlayer
onready var anim_player_intro = $PlayerIntro_AnimationPlayer
onready var Player_sprite = $Player_Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


""" callbacks """

func _input(event):
	pass
#	if event.is_action_pressed("mouse_left_click"):
#		print("click, pos: " + str(self.position.y) + "\n")

""" physics """

func _physics_process(delta):
	
	""" running """
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if (input_vector != Vector2.ZERO):
		if (input_vector.x > 0):
			Player_animationPlayer.play("Player_Right_Run")
			last_run_direction = ConstantsEnums.DIRECTION.RIGHT
		elif (input_vector.x < 0):
			Player_animationPlayer.play("Player_Left_Run")
			last_run_direction = ConstantsEnums.DIRECTION.LEFT
		elif (input_vector.y < 0):
			Player_animationPlayer.play("Player_Back_Run")
			last_run_direction = ConstantsEnums.DIRECTION.UP
		elif (input_vector.y > 0):
			Player_animationPlayer.play("Player_Front_Run")
			last_run_direction = ConstantsEnums.DIRECTION.DOWN

		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else: 
		match last_run_direction:
			ConstantsEnums.DIRECTION.RIGHT:
				Player_animationPlayer.play("Player_Right_Idle")
			ConstantsEnums.DIRECTION.LEFT:
				Player_animationPlayer.play("Player_Left_Idle")
			ConstantsEnums.DIRECTION.UP:
				Player_animationPlayer.play("Player_Back_Idle")
			ConstantsEnums.DIRECTION.DOWN:
				Player_animationPlayer.play("Player_Front_Idle")
			_:
				Player_animationPlayer.play("Player_Front_Idle")

		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)

