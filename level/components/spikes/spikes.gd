extends Node2D

@export var number_of_spikes := 1
@export var spike_packed_scene: PackedScene	


func _ready() -> void:
	create_spike(number_of_spikes)

func create_spike(amount):
	var current_spikes = 1
	while current_spikes < number_of_spikes:
		var new_spike = spike_packed_scene.instantiate()
		add_child(new_spike)
		new_spike.set_position(Vector2(32*current_spikes,0))
		current_spikes+=1
		print("created spike at", str(new_spike.position))
		pass
