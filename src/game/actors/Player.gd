extends RigidBody2D

const WALK_ACCEL = 700.0
const WALK_DEACCEL = 150.0
const WALK_MAX_VELOCITY = 140.0
const AIR_ACCEL = 600.0
const AIR_DEACCEL = 50.0
const JUMP_VELOCITY = 380
const STOP_JUMP_FORCE = 450.0
const MAX_FLOOR_AIRBORNE_TIME = 0.15
const MAX_AIR_JUMPS = 1

var anim = ""
var jumps = 0
var jumping = false
var stopping_jump = false

onready var sprite = $Sprite

var floor_h_velocity = 0.0

var airborne_time = 1e20

func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()

	var new_anim = anim

	# Get player input.
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")

	# Deapply prev floor velocity.
	lv.x -= floor_h_velocity
	floor_h_velocity = 0.0

	# Find the floor (a contact with upwards facing collision normal).
	var found_floor = false
	var floor_index = -1

	for x in range(s.get_contact_count()):
		var ci = s.get_contact_local_normal(x)

		if ci.dot(Vector2(0, -1)) > 0.6:
			found_floor = true
			floor_index = x

	if jump and not jumping:
		if jump and jumps < MAX_AIR_JUMPS:
			lv.y = -JUMP_VELOCITY
			jumps += 1
			stopping_jump = false
		else:
			if jumps > 0 and lv.y < 0 and not jump:
				stopping_jump = true
				lv.y += STOP_JUMP_FORCE * step

	if found_floor:
		airborne_time = 0.0
	else:
		airborne_time += step # Time it spent in the air.

	var on_floor = airborne_time < MAX_FLOOR_AIRBORNE_TIME

	if on_floor:
		# Process logic when character is on floor.
		jumps = 0

		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= WALK_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += WALK_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= WALK_DEACCEL * step
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv

		
		if jumps > 0:
			new_anim = "jumping"
		elif abs(lv.x) < 0.1:
			new_anim = "default"
		else:
			if lv.x < 0 and move_left:
				new_anim = "walk_left"
				$Lantern.scale.x = -1
				$Lantern.position.x = -14
				$Lantern/sprite.animation = "walk"
			elif lv.x > 0 and move_right:
				new_anim = "walk_right"
				$Lantern.scale.x = 1
				$Lantern.position.x = 14
				$Lantern/sprite.animation = "walk"
			else:
				$Lantern/sprite.animation = "idle"
	else:
		# Process logic when the character is in the air.
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= AIR_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += AIR_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= AIR_DEACCEL * step

			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv

		if lv.y < 0:
			pass
			#new_anim = "jumping"
		else:
			pass
			#new_anim = "falling"

	# Change animation.
	if new_anim != anim:
		anim = new_anim
		sprite.animation = anim

	jumping = jump

	# Apply floor velocity.
	if found_floor:
		floor_h_velocity = s.get_contact_collider_velocity_at_position(floor_index).x
		lv.x += floor_h_velocity

	# Finally, apply gravity and set back the linear velocity.
	lv += s.get_total_gravity() * step
	s.set_linear_velocity(lv)
