extends Button

const DELAY_TIME_ANIMATE = 0.2
class_name BtnBlock

var blocktype = 0
var rotation_degrees = 0

#var connect_left = false
#var connect_right = false
#var connect_top = false
#var connect_bottom = false
#var is_last_path = false

var links = []
var col = 0
var row = 0

const ROTATE_DEGREES = 90

signal block_pressed

func _ready():			
#	_set_connect_side()
	set_rotate_degrees(rotation_degrees, false)		
		
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
	tween.interpolate_property(block, "rotation", block.rotation, block.rotation+rotVal, DELAY_TIME_ANIMATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_callback(self, DELAY_TIME_ANIMATE, "on_rotate_completed")

func on_rotate_completed():
	emit_signal("block_pressed", row , col, ROTATE_DEGREES)
		
	
func clear_link_block():
	for link_block in links:
		link_block.links.erase(self)

	links.clear()	
	
func _on_BtnBlock_pressed():		
	rotation_degrees += ROTATE_DEGREES
	set_rotate_degrees(ROTATE_DEGREES, true)	
			
#	

func move_to(x, y, animate=false, delay_time=DELAY_TIME_ANIMATE):
	if !animate:
		self.rect_position.x = x
		self.rect_position.y = y
	else:
		var tween = Tween.new()
		add_child(tween)		
		tween.interpolate_property(self, "rect_position", self.rect_position, Vector2(x, y), delay_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
		tween.start()
