extends Node2D

const BLOCK_W = 80

var value_block = []
var block_data = []		
# Called when the node enters the scene tree for the first time.
func _ready():		
	value_block = gen_value_block()
	create_block()
	
	var block_path = find_block_pass_path()
	if len(block_path) > 0 :
		print("found", block_path)
	else:
		print("not found")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func create_block():
	print("create_block")
	
	for r in range (0, 5):
		var row = []
		for c in range(0, 4):			
			var block = gen_block( r, c)
			block.row = r
			block.col = c			
			self.add_child(block)
						
			if c == 3:
				block.is_last_path = true
			
			if c > 0:
				if block.connect_left == true and row[c-1].connect_right == true:					
					row[c-1].links.append(block)
					block.links.append(row[c-1])
			
			if r > 0:
				if block.connect_top == true and block_data[r-1][c].connect_bottom == true:					
					block_data[r-1][c].links.append(block)
					block.links.append(block_data[r-1][c])

			row.append(block)			
		block_data.append(row)			
	
	show_data(block_data)
	show_connect(block_data)
	show_block_detail(block_data)
	
	
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
			if len(data[r][c].links) > 0:
				s += str(len(data[r][c].links)) + ", "		
			else:
				s += str(len(data[r][c].links)) + ", "				
		print(s)

func show_block_detail(data):
	print("--")
	for r in range(0, 5):		
		for c in range (0, 4):
			print(r, " ", c, ": ", 
				block_data[r][c].connect_left, " ", 
				block_data[r][c].connect_top," ", 
				block_data[r][c].connect_right, " ", 
				block_data[r][c].connect_bottom)



func gen_value_block():
	return [
		[0, 0, 0, 0],
		[0, 90, 0, 0],
		[0, 90, 0, 180],
		[0, 90, 0, 0],
		[0, 0, 90, 0],
	]	
	
func gen_block(r, c):		
	var block = preload("res://scenes/BtnBlock.tscn").instance()	
	
	block.rect_position.x = c * BLOCK_W + (BLOCK_W/2)
	block.rect_position.y = r * BLOCK_W + (BLOCK_W/2)	
	block.blocktype = 0		
	
	#	var rng = RandomNumberGenerator.new()
#	rng.randomize()
#	var random = rng.randi_range(0, 3)
#	var degree = 90 * random
	block.rotation_degrees  = value_block[r][c]
	
	block.connect("block_pressed", self, "on_block_pressed")	
	
	return block
	
func on_block_pressed(block: BtnBlock):
	print("receive signal block_pressed", block)	
	print("> ",block.rotation_degrees, " ", block.connect_left, block.connect_top, block.connect_right, block.connect_bottom)	
	clear_link_block(block)
	set_link_block(block)
	
#	show_data(block_data)
	show_connect(block_data)
#	show_block_detail(block_data)
	
func clear_link_block(block: BtnBlock):
	block.clear_link_block()

	
	
	
func set_link_block(block: BtnBlock):		
	if block.connect_left == true and block.col-1 >= 0 and block_data[block.row][block.col-1].connect_right == true :
		block_data[block.row][block.col-1].links.append(block)
		block.links.append(block_data[block.row][block.col-1])

	if block.connect_top == true and block.row-1 >= 0 and block_data[block.row-1][block.col].connect_bottom == true :
		block_data[block.row-1][block.col].links.append(block)
		block.links.append(block_data[block.row-1][block.col])
#
	if block.connect_right == true and block.col+1 < 4 and block_data[block.row][block.col+1].connect_left == true:
		block.links.append(block_data[block.row][block.col+1])
		block_data[block.row][block.col+1].links.append(block)
#
	if block.connect_bottom == true and block.row +1 < 5 and block_data[block.row+1][block.col].connect_top == true :
		block.links.append(block_data[block.row+1][block.col])
		block_data[block.row+1][block.col].links.append(block)

		
func check_block(block: BtnBlock, blockpath):
	print(" >> block check: ", block, ", ", blockpath)
	
	if block.is_last_path == true and block.connect_right == true:
		print("final : ", blockpath)
		return blockpath
	else:	
		
		var block_next = block.links
		print("next : ", block_next)
#
		if len(blockpath) > 0 :				
			for b_chk in blockpath:
				for b in block_next:				
					if b_chk != b:
						block_next.erase(b_chk)
		for b in block_next:
			print("next : ", b)
			blockpath.append(block)
			return check_block(b, blockpath)				
			
		return []	

func find_block_pass_path():
	var head_blocks = [
		block_data[0][0], 
		block_data[1][0],
		block_data[2][0],
		block_data[3][0],
		block_data[4][0],
	]
		
	print(block_data[0][0], " ", block_data[0][1], " ", block_data[0][2], " ", block_data[0][3])
	print(block_data[0][0].links)
	print(block_data[0][1].links)
	print(block_data[0][2].links)
	print(block_data[0][3].links)
	for block_start in head_blocks:
		var paths = check_block(block_start, [])
		print(paths)
		if len(paths) != 0:
			return paths		
	
	return []

	

	
	
	
	
