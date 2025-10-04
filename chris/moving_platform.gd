extends AnimatableBody2D

# Movement settings
@export var move_distance: Vector2 = Vector2(300, 0)  # Wie weit sich die Plattform bewegt
@export var move_duration: float = 2.0  # Wie lange die Bewegung dauert (in Sekunden)
@export var wait_time: float = 1.0  # Wartezeit an den Endpunkten
@export var start_automatically: bool = true  # Startet automatisch beim Laden
@export var loop_type: String = "ping_pong"  # "ping_pong" oder "loop"

# Internal variables
var start_position: Vector2
var target_position: Vector2
var is_moving: bool = false
var tween: Tween

func _ready():
	# Speichere die Startposition
	start_position = global_position
	target_position = start_position + move_distance
	
	# Starte automatisch wenn gewünscht
	if start_automatically:
		start_movement()

func start_movement():
	if is_moving:
		return
	
	is_moving = true
	move_to_target()

func move_to_target():
	# Erstelle einen neuen Tween
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	# Bewege zur Zielposition
	tween.tween_property(self, "global_position", target_position, move_duration)
	
	# Warte am Endpunkt
	tween.tween_interval(wait_time)
	
	# Wenn ping_pong, bewege zurück
	if loop_type == "ping_pong":
		tween.tween_property(self, "global_position", start_position, move_duration)
		tween.tween_interval(wait_time)
	
	# Wenn loop, springe zurück zum Start
	elif loop_type == "loop":
		tween.tween_callback(func(): global_position = start_position)
	
	# Wiederhole die Bewegung
	tween.tween_callback(move_to_target)

func stop_movement():
	is_moving = false
	if tween:
		tween.kill()
