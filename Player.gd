extends RigidBody3D

## How much vertical force to apply when moving.
@export_range(750.0, 3000.0) var thrust: float = 1000.0
## How much angular thrust to apply when rotating.
@export_range(0, 500) var torque_thrust = 100.0

var is_transitioning: bool = false

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio

@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var rocket_audio_left: AudioStreamPlayer3D = $RocketAudioLeft
@onready var rocket_audio_right: AudioStreamPlayer3D = $RocketAudioRight

@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var booster_particles_2: GPUParticles3D = $BoosterParticles2
@onready var booster_particles_3: GPUParticles3D = $BoosterParticles3

@onready var booster_particles_left: GPUParticles3D = $BoosterParticlesLeft
@onready var booster_particles_right: GPUParticles3D = $BoosterParticlesRight

@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		booster_particles.emitting = true
		booster_particles_2.emitting = true
		booster_particles_3.emitting = true
		if rocket_audio.playing == false:
			rocket_audio.play()
	else:
		booster_particles.emitting = false
		booster_particles_2.emitting = false
		booster_particles_3.emitting = false
		rocket_audio.stop()


	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, 1.0) * delta * torque_thrust)
		booster_particles_right.emitting = true
		if rocket_audio_right.playing == false:
			rocket_audio_right.play()
	else:
		booster_particles_right.emitting = false
		rocket_audio_right.stop()

	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -1.0) * delta * torque_thrust)
		booster_particles_left.emitting = true
		if rocket_audio_left.playing == false:
			rocket_audio_left.play()
	else:
		booster_particles_left.emitting = false
		rocket_audio_left.stop()

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_body_entered(body: Node) -> void:
	if is_transitioning == false:
		if "goal" in body.get_groups():
			complete_level(body.file_path)
		if "hazard" in body.get_groups():
			crash_sequence()


func crash_sequence() -> void:
	print("KABOOM!")
	explosion_audio.play()
	explosion_particles.emitting = true
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(get_tree().reload_current_scene)

func complete_level(next_level_file: String) -> void:
	print('You won!')
	success_audio.play()
	success_particles.emitting = true
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level_file)
	)
