extends Node2D

const foods = [
	"food_cheese_butter4",
	"food_cheese_emmental",
	"food_cheese_white",
	"food_cheese_yellow1",
	"food_cheese_yellow2",
	"food_cheese_yellow3",
	"food_cut_seafood_ebi",
	"food_egg_uzura_yudetamago",
	"food_heshiko",
	"food_pizza_cut_bbq",
	"food_pizza_cut_cheese",
	"food_pizza_cut_cheese_tomato",
	"food_pizza_cut_meat",
	"food_pizza_cut_salami",
	"food_torisashi",
]

@export var food_id: int

var dragging: bool = false

signal dragsignal(bool)

func set_pickable(p: bool):
	$Area2D.input_pickable = p
	
func reset_food_id() -> void:
	food_id = randi_range(0, foods.size() - 1)

func _ready() -> void:
	$view.texture = load("./food/" + foods[food_id] + ".png")
	$view.scale = Vector2(0.3, 0.3) # $view.texture.get_size()
	
	connect("dragsignal", _set_drag)

func _set_drag(d: bool):
	dragging = d

func _process(_delta: float) -> void:
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		self.position = Vector2(max(640, mousepos.x), mousepos.y)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("dragsignal", event.pressed)
