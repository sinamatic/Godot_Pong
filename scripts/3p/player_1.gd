extends CharacterBody2D

const MOTION_MULTIPLIER = 4.0

var win_height: int
var p_height: int
var p_width: int
var win_width: int
var osc_value: float  # Aktueller OSC-Wert
var paddle_position_x: float
var paddle_position_y: float


@onready var osc_receiver: Node = $OSCReceiver

func _ready():
	win_height = get_viewport_rect().size.y
	win_width = get_viewport_rect().size.x
	# win_height = $"../../Playground/WoodBackground".size.y
	# win_width = $"../../Playground/WoodBackground".size.x
	p_height = $ColorRect.get_size().y
	p_width = $ColorRect.get_size().x
	
	# print("Position Y:", position.y, "Win Height: ", win_height, "Paddle Height: ", p_height, "Win Width: ", win_width)
	# print("Viewport w: ", get_viewport_rect().size.x, "Viewport height: ", get_viewport_rect().size.y)

func _process(delta):
	if Input.is_key_pressed(KEY_W):
		position.y -= get_parent().get_parent().PADDLE_SPEED * delta
	elif Input.is_key_pressed(KEY_S):
		position.y += get_parent().get_parent().PADDLE_SPEED * delta
	elif Input.is_key_pressed(KEY_A):
		position.x -= get_parent().get_parent().PADDLE_SPEED * delta
	elif Input.is_key_pressed(KEY_D):
		position.x += get_parent().get_parent().PADDLE_SPEED * delta
	
	position.x = clamp(position.x, p_width/2, win_width - p_width/2)
	position.y = clamp(position.y, win_height / 2 - p_height, win_height - p_height)

# Überprüfe alle eingehenden Nachrichten
	if osc_receiver and osc_receiver.has_method("get"):
		var target_server = $OSCServer

	# Initialisiere Variablen für X und Y
		var normalized_x = position.x
		var normalized_y = position.y

		if target_server:
			for address in target_server.incoming_messages.keys():
				var osc_value = target_server.incoming_messages[address][0]
				target_server.incoming_messages.erase(address)  # Nachricht verarbeiten und entfernen

				# Skaliere den OSC-Wert auf den Bildschirmbereich
				var normalized_value = -MOTION_MULTIPLIER * clamp(osc_value, -1, 1)  # Normalisiere den Wert auf [-1, 1]

				if address.ends_with("/x"):
					# Berechne Zielposition für X
					normalized_x = win_width / 2.0 + normalized_value * (win_width / 2.0 - p_width / 2.0)
					print("P1: Empfangene Nachricht: X, Zielposition X:", normalized_x, "Normalisierter X Wert:", normalized_value)

				elif address.ends_with("/y"):
					# Berechne Zielposition für Y
					normalized_y = win_height / 2.0 + normalized_value * (win_height / 2.0 - p_height / 2.0)
					print("P1: Empfangene Nachricht: Y, Zielposition Y:", normalized_y, "Normalisierter Y Wert:", normalized_value)

		# Aktualisiere Paddle-Position für X und Y
		# Begrenzung der X- und Y-Positiongit
		# Aktualisiere Paddle-Position für X und Y mit Begrenzung
		normalized_x = clamp(normalized_x, p_width/2, win_width - p_width/2)
		normalized_y = clamp(normalized_y, win_height / 2 - p_height, win_height - p_height)

		# Setze die geglättete Position
		position.x = lerp(float(position.x), float(normalized_x), delta * 5.0)
		position.y = lerp(float(position.y), float(normalized_y), delta * 5.0)
