class_name Block

var connect_left = false
var connect_right = false
var connect_top = false
var connect_bottom = false
var is_last_path = false

var links = []
var col = 0
var row = 0
var btn_animate : BtnBlock

var blocktype = 0
var rotation_degrees = 0

func _init(blocktype, rotation_degrees):
	self.blocktype = blocktype
	self.rotation_degrees = rotation_degrees
	_set_connect_side(int(self.rotation_degrees%360))
	
func _set_connect_side(degrees):		
	if self.blocktype == 0:		
		match (degrees):
			0, 180:
				connect_left = true
				connect_top = false
				connect_right = true				
				connect_bottom = false
			90, 270:
				connect_left = false
				connect_top = true
				connect_right = false				
				connect_bottom = true			
			_:
				pass
		
func rotate_block(degree):
	self.rotation_degrees += rotation_degrees
	self._set_connect_side(self.rotation_degrees)
	
func clear_link_block():
	for link_block in links:
		link_block.links.erase(self)

	links.clear()
	
