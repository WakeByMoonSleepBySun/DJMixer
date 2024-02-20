extends Node

const bass0 = preload("res://music/DJ Music Time (Bass Var.1).mp3")
const bass1 = preload("res://music/DJ Music Time (Bass Var.2).mp3")
const bass2 = preload("res://music/DJ Music Time (Bass Var.3).mp3")
const bass3 = preload("res://music/DJ Music Time (Bass Var.4).mp3")

const drum0 = preload("res://music/DJ Music Time (Drum Var.1).mp3")
const drum1 = preload("res://music/DJ Music Time (Drum Var.2).mp3")
const drum2 = preload("res://music/DJ Music Time (Drum Var.3).mp3")
const drum3 = preload("res://music/DJ Music Time (Drum Var.4).mp3")

const chord0 = preload("res://music/DJ Music Time (Synth Chord Var.1).mp3")
const chord1 = preload("res://music/DJ Music Time (Synth Chord Var.2).mp3")
const chord2 = preload("res://music/DJ Music Time (Synth Chord Var.3).mp3")
const chord3 = preload("res://music/DJ Music Time (Synth Chord Var.4).mp3")

const lead0 = preload("res://music/DJ Music Time (Synth Lead Var.1).mp3")
const lead1 = preload("res://music/DJ Music Time (Synth Lead Var.2).mp3")
const lead2 = preload("res://music/DJ Music Time (Synth Lead Var.3).mp3")
const lead3 = preload("res://music/DJ Music Time (Synth Lead Var.4).mp3")

const arr_bass = [bass0, bass1, bass2, bass3]
const arr_drum = [drum0, drum1, drum2, drum3]
const arr_chord = [chord0, chord1, chord2, chord3]
const arr_lead = [lead0, lead1, lead2, lead3]

var is_audio_playing : bool = false
var is_dj_active : bool = false

var rng = RandomNumberGenerator.new()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var volume = linear_to_db($volume_slider.value)
	adjust_all_track_volumes(volume)
	
	# Randomize, but in a way that all tracks are on
	switch_audio($bassAudio, arr_bass, rng.randi_range(0, 3), $bass_label)
	switch_audio($drumAudio, arr_drum, rng.randi_range(0, 3), $drum_label)
	switch_audio($chordAudio, arr_chord, rng.randi_range(0, 3), $chord_label)
	switch_audio($leadAudio, arr_lead, rng.randi_range(0, 3), $lead_label)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var position = $bassAudio.get_playback_position()

func _play_button_pressed():
	if(!is_audio_playing): play_all_audios()
	is_audio_playing = true

func _stop_button_pressed():
	is_audio_playing = false
	stop_all_audios()
	
func play_all_audios():
	$bassAudio.play(0.0)
	$drumAudio.play(0.0)
	$chordAudio.play(0.0)
	$leadAudio.play(0.0)
	$guideTrack.play(0.0)

func stop_all_audios():
	$bassAudio.stop()
	$drumAudio.stop()
	$chordAudio.stop()
	$leadAudio.stop()
	$guideTrack.stop()

func track_button_pressed(track_type : String, track_index : int):
	match track_type:
		'bass':
			switch_audio($bassAudio, arr_bass, track_index, $bass_label)
		'drum':
			switch_audio($drumAudio, arr_drum, track_index, $drum_label)
		'chord':
			switch_audio($chordAudio, arr_chord, track_index, $chord_label)
		'lead':
			switch_audio($leadAudio, arr_lead, track_index, $lead_label)

func switch_audio(audio : AudioStreamPlayer, track_array: Array, track_index: int, label: RichTextLabel):
	# Handle audio
	var position = audio.get_playback_position()
	if(track_index == 4): audio.stream = null
	else: audio.stream = track_array[track_index]
	
	if(is_audio_playing): audio.play(position)
	
	# Handle visual
	if(track_index == 4): label.text = "-"
	else: label.text = str(track_index + 1)

func adjust_volume(value: float):
	var volume = linear_to_db(value)
	adjust_all_track_volumes(volume)

func adjust_all_track_volumes(volume: float):
	$bassAudio.volume_db = volume
	$drumAudio.volume_db = volume
	$chordAudio.volume_db = volume
	$leadAudio.volume_db = volume

func activate_dj_toggled(toggled_on: bool):
	is_dj_active = toggled_on
	
	# Disable/Enable btns
	$bass0.disabled = toggled_on
	$bass1.disabled = toggled_on
	$bass2.disabled = toggled_on
	$bass3.disabled = toggled_on
	$bass4.disabled = toggled_on
	$drum0.disabled = toggled_on
	$drum1.disabled = toggled_on
	$drum2.disabled = toggled_on
	$drum3.disabled = toggled_on
	$drum4.disabled = toggled_on
	$chord0.disabled = toggled_on
	$chord1.disabled = toggled_on
	$chord2.disabled = toggled_on
	$chord3.disabled = toggled_on
	$chord4.disabled = toggled_on
	$lead0.disabled = toggled_on
	$lead1.disabled = toggled_on
	$lead2.disabled = toggled_on
	$lead3.disabled = toggled_on
	$lead4.disabled = toggled_on

# This is called when the guideTrack completes
# guideTrack does not auto loop so we can catch the
# completion event and then replay it
func handle_track_finish():
	if (is_audio_playing): $guideTrack.play()
	if(is_dj_active && is_audio_playing):
		shuffle_track()

func shuffle_track():
	# TODO: Play around with these values, maybe make it more rare for nothing to change?
	# TODO: Make sure only 2 tracks can be off at once
	var track_type = rng.randi_range(0, 4)
	var track_index = rng.randi_range(0, 4)
	match track_type:
		0:
			switch_audio($bassAudio, arr_bass, track_index, $bass_label)
		1:
			switch_audio($drumAudio, arr_drum, track_index, $drum_label)
		2:
			switch_audio($chordAudio, arr_chord, track_index, $chord_label)
		3:
			switch_audio($leadAudio, arr_lead, track_index, $lead_label)
