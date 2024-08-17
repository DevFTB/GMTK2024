extends Resource
class_name PlayerStats

@export_group("Movement")
## The top horizontal movement speed
@export var max_speed := 14

## The player's capacity to gain horizontal speed
@export var acceleration := 120

## The pace at which the player comes to a stop
@export var ground_deceleration := 60

## Deceleration in air only after stopping input mid-air"
@export var air_deceleration := 30

## A constant downward force applied while grounded. Helps on slopes
@export var grounding_force := 1.5

@export_group("Jump")
## The immediate velocity applied when jumping
@export var jump_power := 36

## The maximum vertical movement speed
@export var max_fall_speed := 40

## The player's capacity to gain fall speed. a.k.a. In Air Gravity
@export var fall_acceleration := 110

## The gravity multiplier added when jump is released early
@export var jump_end_early_gravity_modifier := 3

## The time before coyote jump becomes unusable. Coyote jump allows jump to execute even after leaving a ledge
@export var coyote_time := .15

## The amount of time we buffer a jump. This allows jump input before actually hitting the ground
@export var jump_buffer := .2

@export var can_double_jump := false

@export var can_glide := false
@export var glide_modifier := 0.1

@export var mass : float
