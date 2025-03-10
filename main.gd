extends Node

const food_coords = [
	Vector2(0, -100),
	Vector2(-100, 0),
	Vector2(100, 0),
	Vector2(-100, 100),
	Vector2(100, 100),
]

@export var reference_foods: PackedScene
@export var try_foods: PackedScene
@export var score = 0

const init_time_left = 60

var time_count: int = init_time_left
var refs = {}
var trys = {}

func _ready() -> void:
	for v in food_coords:
		var r = reference_foods.instantiate()
		r.reset_food_id()
		while r.food_id in refs:
			r.reset_food_id()
		refs[r.food_id] = r
		r.position = $Reference.position + v
		r.set_pickable(false)
		
		add_child(r)

	var keys: Array = refs.keys()
	keys.shuffle()
	for n in keys.size():
		var t = try_foods.instantiate()
		t.food_id = keys[n]
		trys[t.food_id] = t
		t.position = Vector2(1200, 200 + n * 100)
		t.set_pickable(true)
		
		add_child(t)
		
	$RetryButton.visible = false
	$Button.visible = true
	$ScoreLabel.visible = false
	$ScoreTimer.start()

func _on_score_timer_timeout() -> void:
	time_count -= 1
	$CountLabel.text = str(time_count)
	
	if time_count < 0:
		_on_button_pressed()

func _on_button_pressed() -> void:
	$ScoreTimer.stop()
	for k in trys:
		trys[k].set_pickable(false)
	$ScoreLabel.visible = true
	score = 1000
	for k in trys:
		var try_pos: Vector2 = ($Try.position - trys[k].position)
		var ref_pos: Vector2 = ($Reference.position - refs[k].position)
		score -= abs(try_pos.distance_to(ref_pos))
	score = max(0, score)
	$ScoreLabel.text = str(int(score))
	$RetryButton.visible = true
	$Button.visible = false
	refs = {}
	trys = {}

func _on_retry_button_pressed() -> void:
	get_tree().call_group("food", "queue_free")
	_ready()
