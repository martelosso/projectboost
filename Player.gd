extends RigidBody3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		apply_central_force(basis.y * delta * 1000.0)

	if Input.is_key_pressed(KEY_A):
		apply_torque(Vector3(0.0, 0.0, 1.0) * delta * 100.0)

	if Input.is_key_pressed(KEY_D):
		apply_torque(Vector3(0.0, 0.0, -1.0) * delta * 100.0)


