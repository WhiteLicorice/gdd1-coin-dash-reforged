class_name BGMPlayer extends AudioStreamPlayer

func change_music(new_stream: AudioStream) -> void:
	if stream == new_stream and playing:
		return

	stream = new_stream
	
	if stream:
		play()
		print("(BGMPlayer) change_music: playing %s" % new_stream.resource_path)
	else:
		stop()
