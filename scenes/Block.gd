extends AnimatedSprite

var blocktype = 0
var connect_left = false
var connect_right = false
var connect_top = false
var connect_bottom = false

var links = []

func _ready():
	_set_connect(self.rotation_degrees)
		
	
func _set_connect(degree):	
	if self.blocktype == 0:		
		match (int(degree)):
			0, 180:
				connect_left = true
				connect_right = true
				connect_top = false
				connect_bottom = false
			90, 270:
				connect_left = false
				connect_right = false
				connect_top = true
				connect_bottom = true			
			_:
				pass
		

func clear_link_block():
	for link_block in links:
		link_block.links.remove(self)
	

