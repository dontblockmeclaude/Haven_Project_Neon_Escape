extends Node

const RATE = 22050
var sounds = {}
var players = []
var next = 0

func _ready():
	print("Sfx ready, sounds: ", sounds.size())
	for i in 6:
		var p = AudioStreamPlayer.new()
		add_child(p)
		players.append(p)
	sounds["pickup"] = _stream(_join([
		_tone(880.0, 0.07, 0.25, "square"), _tone(1175.0, 0.07, 0.25, "square"),
		_tone(1568.0, 0.07, 0.25, "square"), _tone(2093.0, 0.14, 0.25, "square")]))
	sounds["unlock"] = _stream(_join([
		_tone(300.0, 0.4, 0.25, "square", 1300.0), _tone(1046.0, 0.4, 0.3)]))
	sounds["denied"] = _stream(_join([
		_tone(140.0, 0.12, 0.35, "square"), _tone(120.0, 0.15, 0.35, "square")]))
	sounds["hit"] = _stream(_tone(300.0, 0.3, 0.4, "square", 80.0))
	sounds["win"] = _stream(_join([
		_tone(523.0, 0.12, 0.3), _tone(659.0, 0.12, 0.3), _tone(784.0, 0.12, 0.3),
		_tone(1046.0, 0.12, 0.3), _tone(1318.0, 0.5, 0.3)]))
	sounds["lose"] = _stream(_tone(440.0, 1.0, 0.35, "square", 60.0))
	sounds["tick"] = _stream(_tone(1000.0, 0.05, 0.3, "square"))
	sounds["click"] = _stream(_tone(660.0, 0.06, 0.3))

func play(sound_name, volume_db = 0.0):
	if not sounds.has(sound_name):
		return
	var p = players[next]
	next = (next + 1) % players.size()
	p.stream = sounds[sound_name]
	p.volume_db = volume_db
	p.play()
	print("play: ", sound_name)

func _tone(freq, dur, vol = 0.4, kind = "sine", freq_end = -1.0):
	var n = int(dur * RATE)
	var out = PackedFloat32Array()
	out.resize(n)
	var phase = 0.0
	for i in n:
		var t = float(i) / RATE
		var f = freq
		if freq_end > 0.0:
			f = lerpf(freq, freq_end, t / dur)
		phase += TAU * f / RATE
		var s = sin(phase)
		if kind == "square":
			s = 0.6 if s >= 0.0 else -0.6
		var env = exp(-5.0 * t / dur) * minf((dur - t) / 0.01, 1.0)
		out[i] = s * env * vol
	return out

func _join(parts):
	var out = PackedFloat32Array()
	for p in parts:
		out.append_array(p)
	return out

func _stream(samples):
	var data = PackedByteArray()
	data.resize(samples.size() * 2)
	for i in samples.size():
		data.encode_s16(i * 2, int(clampf(samples[i], -1.0, 1.0) * 32767.0))
	var s = AudioStreamWAV.new()
	s.format = AudioStreamWAV.FORMAT_16_BITS
	s.mix_rate = RATE
	s.stereo = false
	s.data = data
	return s
