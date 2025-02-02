extends AudioStreamPlayer

func _play_another_song(song:AudioStream):
	if song != stream:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "volume_db", -80, 0.5)
		tween.parallel().tween_property(self, "pitch_scale", 0.5, 0.3)
		tween.tween_property(self, "playing", false, 0.01)
		tween.tween_property(self, "stream", song, 0.5)
		tween.tween_property(self, "playing", true, 0.01)
		tween.tween_property(self, "volume_db", 0.0, 0.5)
		tween.parallel().tween_property(self, "pitch_scale", 1.0, 0.7)
