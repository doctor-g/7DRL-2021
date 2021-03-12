extends TextureRect
tool

export var spritesheet : Texture = preload("res://assets/monochrome_transparent_packed.png")
export var frame := 0 setget _set_frame
export var cell_size := 16

func _ready():
	_update_texture()


func _update_texture():
	texture = _extract_texture(spritesheet)


func _extract_texture(original:Texture)->Texture:
	var result := AtlasTexture.new()
	result.atlas = original
# warning-ignore:integer_division
	var columns := original.get_width() / cell_size
	var x : int = frame % columns
# warning-ignore:integer_division
	var y : int = frame / columns
	result.region = Rect2(x*16,y*16,16,16)
	return result


func _set_frame(value):
	frame = value
	_update_texture()
