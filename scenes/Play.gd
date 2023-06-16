extends Node2D

const BLOCK_W = 80

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body
	create_block()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func create_block():
	print("create_block")
	var data = []		
	for r in range (0, 5):
		var row = []
		for c in range(0, 4):			
			var block = gen_block( r, c)					
			self.add_child(block)						
			#check left chain
			if c != 0:
				if block.connect_left == true and row[c-1].connect_right == true:
					block.links.append(row[c-1])
					row[c-1].links.append(block)
			
			#check top chain
			if r != 0:	
				if block.connect_top == true and data[r-1][c].connect_bottom == true:
					block.links.append(data[r-1][c])
					data[r-1][c].links.append(block)							
			row.append(block)			
		data.append(row)			
	
	show_data(data)
	show_connect(data)
	show_block_detail(data)
	
	
func show_data(data):
	for r in range(0, 5):
		var s = ""
		for c in range (0, 4):
			s += str(data[r][c].rotation_degrees) + ", "
				
		print(s)
		
func show_connect(data):
	print("--")
	for r in range(0, 5):
		var s = ""
		for c in range (0, 4):
			s += str(len(data[r][c].links)) + ", "				
		print(s)

func show_block_detail(data):
	print("--")
	for r in range(0, 5):		
		for c in range (0, 4):
			print(r, " ", c, ": ", 
				data[r][c].connect_left, " ", 
				data[r][c].connect_right," ", 
				data[r][c].connect_top, " ", 
				data[r][c].connect_bottom)

func gen_block(r, c):		
	var block = preload("res://scenes/BtnBlock.tscn").instance()	
	
	block.rect_position.x = c * BLOCK_W + (BLOCK_W/2)
	block.rect_position.y = r * BLOCK_W + (BLOCK_W/2)	
	block.blocktype = 0	

	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random = rng.randi_range(0, 3)
	var degree = 90 * random

	block.rotation_degrees = degree	
	block.connect("block_pressed", self, "on_block_pressed")
	
	return block
	
func on_block_pressed(block):
	print("receive signal block_pressed", block)
	
