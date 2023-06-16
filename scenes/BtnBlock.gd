extends Button

const DELAY_TIME_ANIMATE = 0.2

var blocktype = 0
var rotation_degrees = 0
var connect_left = false
var connect_right = false
var connect_top = false
var connect_bottom = false

var links = []

const ROTATE_DEGREES = 90

signal block_pressed

func _ready():	
	_set_connect()
	set_rotate_degrees(rotation_degrees, true)
	pass
		

func set_rotate_degrees(degrees, animate):	 
	if animate == true:
		rotate_block_tween(self.get_child(0), degrees)
	else:
		$AnimatedSprite.rotation_degrees = degrees


func rotate_block_tween(block, degree):	
	var tween = Tween.new()
	add_child(tween)
	var rotVal = degree * (PI / 180)
	
	tween.interpolate_property(block, "rotation", block.rotation, block.rotation+rotVal, DELAY_TIME_ANIMATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
		
	
func _set_connect():		
	if self.blocktype == 0:		
		match (int(self.rotation_degrees)):
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
		link_block.links.erase(self)
		
	links.clear()
	
func _on_BtnBlock_pressed():		
	rotation_degrees += ROTATE_DEGREES
	set_rotate_degrees(ROTATE_DEGREES, true)	
			
	emit_signal("block_pressed", self)