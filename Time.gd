extends Node


var _savefile_name = "user://perm_config.save"
var _savefile = {
	"last_server_time":0,
	"system_tick_last_server_time":0,
	"game_tick_last_server_time":0,
	"start_system_time":0,
	"system_tick_start_system_time":0,
	"game_tick_start_system_time":0
}


func _ready() -> void:
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	load_save()
	var cur_system_time : float = Time.get_unix_time_from_system()
	_savefile["start_system_time"] = cur_system_time
	_savefile["game_tick_start_system_time"] = Time.get_ticks_msec() / 1000.0
	if Engine.has_singleton("TimeKeeper"):
		var singleton = Engine.get_singleton("TimeKeeper")
		var andro_ms : int = int(singleton.elapsedRealTime())
		_savefile["system_tick_start_system_time"] = andro_ms / 1000.0
	get_server_time()

	

func _process(delta: float) -> void:
		
	save()
	
	# Solution 1: Get time from system: BAD
	var cur_system_time_dict : Dictionary = Time.get_datetime_dict_from_system(true)
	$VBoxContainer/HBoxContainer2/Date.text = "{year}-{month}-{day}".format({
		"year":cur_system_time_dict["year"], 
		"month":"%02d" % cur_system_time_dict["month"], 
		"day":"%02d" % cur_system_time_dict["day"]})
	$VBoxContainer/HBoxContainer/Time.text = "{hour}:{minute}:{second}".format({
		"hour":"%02d" % cur_system_time_dict["hour"], 
		"minute":"%02d" % cur_system_time_dict["minute"], 
		"second":"%02d" % cur_system_time_dict["second"]})
		
	# Solution Number 2: Get time from the system once at launch 
	# then you use delta time
	_savefile["start_system_time"] += delta
	var start_system_time_dict = Time.get_time_dict_from_unix_time(_savefile["start_system_time"])
	$VBoxContainer/HBoxContainer6/AdjOSTime.text = "{hour}:{minute}:{second}".format({
		"hour":"%02d" % start_system_time_dict["hour"], 
		"minute":"%02d" % start_system_time_dict["minute"], 
		"second":"%02d" % start_system_time_dict["second"]})
		
	# Solution Number 4: Use Server Time + game ticks
	var server_delta : float = (Time.get_ticks_msec() / 1000.0) - _savefile.get("game_tick_last_server_time", 0)
	var unix_game_srv_time = _savefile.get("last_server_time", 0) + server_delta
	var start_server_time_dict = Time.get_time_dict_from_unix_time(unix_game_srv_time)
	$VBoxContainer/HBoxContainer8/AdjSrvTime.text = "{hour}:{minute}:{second}".format({
		"hour":"%02d" % start_server_time_dict["hour"], 
		"minute":"%02d" % start_server_time_dict["minute"], 
		"second":"%02d" % start_server_time_dict["second"]})
		
	# Solution Number 5: Use Server Time + game ticks
	var unix_sys_srv_time = 0
	if Engine.has_singleton("TimeKeeper"):
		var singleton = Engine.get_singleton("TimeKeeper")
		var andro_ms : int = int(singleton.elapsedRealTime())
		
		var server_delta_sys : float = (andro_ms / 1000.0) - _savefile.get("system_tick_last_server_time", 0)
		unix_sys_srv_time = _savefile.get("last_server_time", 0) + server_delta_sys
		var start_server_sys_time_dict = Time.get_time_dict_from_unix_time(unix_sys_srv_time)
		$VBoxContainer/HBoxContainer4/SysSrvTime.text = "{hour}:{minute}:{second}".format({
			"hour":"%02d" % start_server_sys_time_dict["hour"], 
			"minute":"%02d" % start_server_sys_time_dict["minute"], 
			"second":"%02d" % start_server_sys_time_dict["second"]})
		
	
	# Solution Number 3: Is To "punish" cheater
	var max_unix_time = max(Time.get_unix_time_from_system(), _savefile["start_system_time"])
	max_unix_time = max(max_unix_time, unix_game_srv_time)
	if Engine.has_singleton("TimeKeeper"):
		max_unix_time = max(max_unix_time, unix_sys_srv_time)
		
	var punish_time_dict = Time.get_time_dict_from_unix_time(max_unix_time)
	$VBoxContainer/HBoxContainer5/Punish.text = "{hour}:{minute}:{second}".format({
			"hour":"%02d" % punish_time_dict["hour"], 
			"minute":"%02d" % punish_time_dict["minute"], 
			"second":"%02d" % punish_time_dict["second"]})
	

func ms_to_str(time_ms : int) -> String:
	var time_ms_h : int = floor(time_ms / 3600000.0)
	var time_ms_m : int = floor((time_ms - (time_ms_h*3600000.0)) / 60000.0)
	var time_ms_s : int = floor((time_ms - (time_ms_h*3600000.0) - (time_ms_m*60000.0)) / 1000.0)
	var time_ms_ms : int = floor(time_ms - (time_ms_h*3600000.0) - (time_ms_m*60000.0) - (time_ms_s*1000.0))
	return "({h}:{m}:{s}.{ms})".format({
		"h":"%02d" % time_ms_h, 
		"m":"%02d" % time_ms_m,
		"s":"%02d" % time_ms_s,
		"ms":"%03d" % time_ms_ms})


func get_server_time():
	if _savefile.get("internet", true):
		$HTTPRequest.request("https://google.com/")
		
	
	
func _on_request_completed(result, response_code, headers, body):
	if response_code != 200:
		return
	var datetime_dict := {}
	for head in headers:
		if "Date:" in head:
			var arr = head.split(" ", false)
			datetime_dict["day"] = int(arr[2].replace(",", ""))
			var month = arr[3].replace(",", "")
			datetime_dict["year"] = int(arr[4].replace(",", ""))
			var time : Array = arr[5].replace(",", "").split(":")
			datetime_dict["hour"] = int(time[0])
			datetime_dict["minute"] = int(time[1])
			datetime_dict["second"] = int(time[2])
			datetime_dict["month"] = _month_str_to_int(month)
	_savefile["last_server_time"] = Time.get_unix_time_from_datetime_dict(datetime_dict)
	_savefile["game_tick_last_server_time"] = Time.get_ticks_msec() / 1000.0
	
	if Engine.has_singleton("TimeKeeper"):
		var singleton = Engine.get_singleton("TimeKeeper")
		var andro_ms : int = int(singleton.elapsedRealTime())
		_savefile["system_tick_last_server_time"] = andro_ms / 1000.0
	
	$VBoxContainer/HBoxContainer7/ServerTime.text = "{hour}:{minute}:{second}".format({
			"hour":"%02d" % datetime_dict["hour"], 
			"minute":"%02d" % datetime_dict["minute"], 
			"second":"%02d" % datetime_dict["second"]})
	var t = get_tree().create_tween()
	$VBoxContainer/HBoxContainer7/ServerTime.modulate = Color(0.0, 1.0, 0.0)
	t.tween_property($VBoxContainer/HBoxContainer7/ServerTime, "modulate", Color.red, 9.0)
	

func _month_str_to_int(month : String) -> int:
	month = month.to_lower()
	if "jan" == month:
		return 1
	if "feb" == month:
		return 2
	if "mar" == month:
		return 3
	if "apr" == month:
		return 4
	if "mai" == month:
		return 5
	if "jun" == month:
		return 6
	if "jul" == month:
		return 7
	if "aug" == month:
		return 8
	if "sep" == month:
		return 9
	if "oct" == month:
		return 10
	if "nov" == month:
		return 11
	if "dec" == month:
		return 12
	return -1



func _on_Timer_timeout() -> void:
	get_server_time()




func load_save():
	if File.new().file_exists(_savefile_name):
		var file = File.new()
		file.open(_savefile_name, file.READ)
		var text = file.get_as_text()
		_savefile = JSON.parse(text).result
		file.close()
		$VBoxContainer/Button.pressed = not _savefile.get("internet", true)
	
	
func save():
	var save_game = File.new()
	save_game.open(_savefile_name, File.WRITE)
	save_game.store_line(to_json(_savefile))
	save_game.close()



func _on_Button_toggled(button_pressed: bool) -> void:
	_savefile["internet"] = not button_pressed
	
	
	
	
