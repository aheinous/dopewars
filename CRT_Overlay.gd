extends Control


#export (Texture) var  texture

onready var viewport = $Viewport

var _lastMouseCCoords = null

#func _draw():
#	var texture = ViewportTexture.new()
#	texture.viewport_path = NodePath('/root/Game/TUI_Overlay')
#	draw_texture(texture,Vector2(200,200))


func _ready():
	
	viewport.size = $'/root'.size

func _draw():
	draw_texture(viewport.get_texture(), Vector2())

#func _process(_delta):
#	update()


func _input(event):
	if event is InputEventMouseMotion:
		var cCoords = TUI.pixelCoordsToCharCoords(event.position)
		if cCoords != _lastMouseCCoords:
			TUI._onMouseMove(cCoords)

	if event is InputEventMouseButton and event.button_index==BUTTON_LEFT:
		var cCoords = TUI.pixelCoordsToCharCoords(event.position)
		if event.pressed:
			TUI._onMousePress(cCoords)
		elif  not event.pressed:
			TUI._onMouseRelease(cCoords)
