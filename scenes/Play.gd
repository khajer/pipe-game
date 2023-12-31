extends Node2D

const BLOCK_W = 80
const MAX_COL = 4
const MAX_ROW = 5
const DELAY_TIME = 1
const ANIMATE_TIME_BOX_DOWN = 0.2	

var block_data = []
var dynamicTimer: Timer
var is_go = false

func _ready():
	
	test()
		
	var value_block = gen_value_block()
	create_block(value_block)
	
	var block_path = find_block_pass_path()
	if len(block_path) > 0 :
		print("found", block_path)
	else:
		print("not found")
		

func create_block(value_block):
	print("create_block : ", value_block)	
	for r in range (0, MAX_ROW):
		var row = []
		for c in range(0, MAX_COL):
			var block = gen_block( r, c, value_block[r][c].degrees)
			set_link_left_top_per_row(block, r, c, row)
			row.append(block)
		block_data.append(row)
	
#	show_data(block_data)
#	show_connect(block_data)
#	show_block_detail(block_data)

func set_link_left_top_per_row(block, r, c, row):
	if c == MAX_COL-1:
		block.is_last_path = true
	
	if c > 0:
		if block.connect_left == true and row[c-1].connect_right == true:
			row[c-1].links.append(block)
			block.links.append(row[c-1])
	
	if r > 0:
		if block.connect_top == true and block_data[r-1][c].connect_bottom == true:
			block_data[r-1][c].links.append(block)
			block.links.append(block_data[r-1][c])
			
			
func show_data(data):
	for r in range(0, MAX_ROW):
		var s = ""
		for c in range (0, MAX_COL):
			s += str(data[r][c].rotation_degrees) + ", "
		print(s)
		
func show_connect(data):
	print("--")
	for r in range(0, MAX_ROW):
		var s = ""
		for c in range (0, MAX_COL):
			if len(data[r][c].links) > 0:
				s += str(len(data[r][c].links)) + ", "
			else:
				s += str(len(data[r][c].links)) + ", "
		print(s)

func show_block_detail(data):
	print("--- block connect [left, top, right, bottom]")
	for r in range(0, MAX_ROW):
		for c in range (0, MAX_COL):
			print(r, " ", c, ": ",
				block_data[r][c].connect_left, " ",
				block_data[r][c].connect_top," ",
				block_data[r][c].connect_right, " ",
				block_data[r][c].connect_bottom)
				
func show_block_degree(data):
	print("--- block degree ")
	for r in range(0, MAX_ROW):
		var s = ""
		for c in range (0, MAX_COL):
			s += str(data[r][c].rotation_degrees)+" "
		print(s)				


func gen_value_block():
	
	return [
		[{degrees=90}, {degrees=0}, {degrees=90}, {degrees=0}],
		[{degrees=90}, {degrees=0}, {degrees=180}, {degrees=270}],
		[{degrees=270}, {degrees=0}, {degrees=90}, {degrees=0}],
		[{degrees=90}, {degrees=180}, {degrees=270}, {degrees=0}],
		[{degrees=90}, {degrees=180}, {degrees=0}, {degrees=180}],
	]
	
#	return [
#		[{degrees=180}, {degrees=0}, {degrees=90}, {degrees=0}],
#		[{degrees=90}, {degrees=0}, {degrees=180}, {degrees=270}],
#		[{degrees=0}, {degrees=0}, {degrees=90}, {degrees=0}],
#		[{degrees=270}, {degrees=180}, {degrees=270}, {degrees=0}],
#		[{degrees=270}, {degrees=180}, {degrees=0}, {degrees=180}],
#	]
	
	# bug 1
#	return [
#		[{degrees=180}, {degrees=0}, {degrees=90}, {degrees=0}],
#		[{degrees=270}, {degrees=180}, {degrees=270}, {degrees=0}],
#		[{degrees=270}, {degrees=180}, {degrees=0}, {degrees=180}],
#		[{degrees=90}, {degrees=0}, {degrees=180}, {degrees=270}],
#		[{degrees=0}, {degrees=0}, {degrees=90}, {degrees=0}],
#	]

#	return [
#		[{degrees=0}, {degrees=90}, {degrees=0}, {degrees=0}],
#		[{degrees=0}, {degrees=90}, {degrees=0}, {degrees=0}],
#		[{degrees=0}, {degrees=90}, {degrees=0}, {degrees=180}],
#		[{degrees=0}, {degrees=0}, {degrees=90}, {degrees=0}],
#		[{degrees=0}, {degrees=0}, {degrees=90}, {degrees=0}],
#	]
	
#	var rng = RandomNumberGenerator.new()
#	rng.randomize()
#	var random = rng.randi_range(0, 3)
#	var degree = 90 * random


#	return [
#		[0, 0, 0, 0],
#		[0, 90, 0, 0],
#		[0, 90, 0, 180],
#		[0, 90, 0, 0],
#		[0, 0, 90, 0],
#	]	
	
func create_button_block(r, c, block_degree):
	var btn_animate = preload("res://scenes/BtnBlock.tscn").instance()		
	btn_animate.rect_position.x = c * BLOCK_W
	btn_animate.rect_position.y = r * BLOCK_W
	btn_animate.blocktype = 0
	btn_animate.rotation_degrees  = block_degree
	btn_animate.connect("block_pressed", self, "on_block_pressed")
	$Blocks.add_child(btn_animate)
	return btn_animate
	
func gen_block(r, c, block_degree):	
	var block = Block.new(0, block_degree)
	block.btn_animate = create_button_block(r, c, block_degree)
	block.setRowCol(r, c)
	block.rotation_degrees = block_degree	
	
	return block
	

func on_block_pressed(r, c, rotation_degrees):
	print(" delegrate button  >- [", r, ", ", c, "] < row, col")
	var block = block_data[r][c]
	print("box[",block.row,",",block.col,"]")
	
	if block.row != r or block.col != c:
		print("!!! ERROR : data row, col block incorect !!!")
#	show_connect(block_data)	
	block.rotate_block(rotation_degrees)
	
	clear_link_block(block)	
	set_link_block(block)
	
	print("---------------------- after click ----------------------")
	show_block_degree(block_data)
#	show_block_detail(block_data)	
	
	print(block_data[4][0], block_data[4][0].links)
	print(block_data[4][1], block_data[4][1].links)
	print(block_data[4][2], block_data[4][2].links)
	print(block_data[4][3], block_data[4][3].links)
		
	check_block_path_allow(r)

func check_block_path_allow(r):
	var block_paths = find_block_pass_path(r)
	
	if len(block_paths) > 0 :
		print("block path found !!! ")
		is_go = !is_go		
		if is_go == true:
			catch_fish_by_cat()
		else:
			go_back_home_cat()
	
		animate_destroy_path(block_paths)
		
	else:
		print("not found !!!")

func go_back_home_cat():
	$Cat.run_to_home()	

func catch_fish_by_cat():
	$Cat.run_to_catch_fish()	
	
func animate_destroy_path(block_paths):
	for blockpath in block_paths:
		for block in blockpath:
			block.is_destroy = true
			block.btn_animate.get_child(0).play("destroy")
		
func add_delay_wait_to_destroy():
	print("add_delay_wait_to_destroy")
	dynamicTimer = Timer.new()
	dynamicTimer.wait_time = DELAY_TIME
	dynamicTimer.one_shot = true
	
	dynamicTimer.connect("timeout", self, "animate_all_block")
	
	if !dynamicTimer.is_inside_tree():
		add_child(dynamicTimer)
		
	dynamicTimer.start()

func animate_all_block():	
	print("animate all block")			
	var timerAnimate = Timer.new()
	timerAnimate.wait_time = ANIMATE_TIME_BOX_DOWN
	timerAnimate.one_shot = true
	timerAnimate.connect("timeout", self, "animate_block_completed")
	if !timerAnimate.is_inside_tree():
		add_child(timerAnimate)
	timerAnimate.start()
	
	for c in MAX_COL:
		put_down_block(c, block_data)
	
	animate_block_on_position(ANIMATE_TIME_BOX_DOWN)


func random_degree():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random = rng.randi_range(0, 3)
	return  90 * random	

func gen4BlockDegree():
	var blocks = []
	for i in range(0, 4):
		blocks.append(random_degree())
	
	return blocks

func isBlockHorizontal(block):
	if block == 0 or block == 180 : 
		return true
	return false
	
func checkPaht4BlockHorizontal(blocks):
	if isBlockHorizontal(blocks[0]) and isBlockHorizontal(blocks[1]) and isBlockHorizontal(blocks[2]) and isBlockHorizontal(blocks[3]) :
		return true
		
	return false
	
	
	
func animate_block_completed():	
	print("create fist row block data !!!!!")
	
	var blocksLineDegree = []
	while true:
		blocksLineDegree = gen4BlockDegree()		
		if !checkPaht4BlockHorizontal(blocksLineDegree):
			break
			
	var c = 0
	for degree in blocksLineDegree :				
		block_data[0][c] = gen_block(0, c, degree)
		c = c+1
	
		

#	block_data[0][0] = gen_block(0, 0, 0)		
#	block_data[0][1] = gen_block(0, 1, 90)		
#	block_data[0][2] = gen_block(0, 2, 180)		
#	block_data[0][3] = gen_block(0, 3, 90)		
	
	clear_link_and_reset_position_btn()	
	set_link()

#	show_data(block_data)
#	show_connect(block_data)
#	show_block_detail(block_data)

func set_link():	
	for r in range(0, MAX_ROW):
		for c in range(0, MAX_COL):		
			set_link_left_top_per_row(block_data[r][c], r, c, block_data[r])


func clear_link_and_reset_position_btn():	
	for r in range(0, MAX_ROW):
		for c in range(0, MAX_COL):
			block_data[r][c].links = []
			block_data[r][c].btn_animate.row = r
			block_data[r][c].btn_animate.col = c
			block_data[r][c].row = r
			block_data[r][c].col = c

func put_down_block(col, src_data):
	var tmp = null
	for row in range(MAX_ROW-1, -1, -1):
		if src_data[row][col].is_destroy == true:
			for r_chk in range(row-1, -1, -1):
				if src_data[r_chk][col].is_destroy == false:
					tmp = src_data[row][col]
					src_data[row][col] = src_data[r_chk][col]
					
					src_data[r_chk][col] = tmp
					break
	
	
func clear_link_block(block: Block):
	block.clear_link_block()
	
	
func set_link_block(block: Block):				
	if block.connect_left == true and block.col-1 >= 0 and block_data[block.row][block.col-1].connect_right == true :
		block_data[block.row][block.col-1].links.append(block)
		block.links.append(block_data[block.row][block.col-1])

	if block.connect_top == true and block.row-1 >= 0 and block_data[block.row-1][block.col].connect_bottom == true :
		block_data[block.row-1][block.col].links.append(block)
		block.links.append(block_data[block.row-1][block.col])
#
	if block.connect_right == true and block.col+1 < MAX_COL and block_data[block.row][block.col+1].connect_left == true:
		block.links.append(block_data[block.row][block.col+1])
		block_data[block.row][block.col+1].links.append(block)
#
	if block.connect_bottom == true and block.row +1 < MAX_ROW and block_data[block.row+1][block.col].connect_top == true :
		block.links.append(block_data[block.row+1][block.col])
		block_data[block.row+1][block.col].links.append(block)

		
func check_block(block: Block, blockpath):
	if block.is_last_path == true and block.connect_right == true:
		blockpath.append(block)
		return blockpath
	else:
		var block_next = block.links
		if len(blockpath) > 0 :
			for b_chk in blockpath:
				for b in block_next:
					if b_chk == b:
						block_next.erase(b_chk)
		for b in block_next:
			blockpath.append(block)
			return check_block(b, blockpath)
		return []

func find_block_pass_path(r=-1):
	var path_all = []
	if r == -1:
		var head_blocks = [
			block_data[0][0],
			block_data[1][0],
			block_data[2][0],
			block_data[3][0],
			block_data[4][0]
		]
		for block_start in head_blocks:					
			var paths = check_block(block_start, [])		
			if len(paths) != 0:
				path_all.append(paths)		
	else:		
		var block_start = block_data[r][0]
		var paths = check_block(block_start, [])		
		if len(paths) != 0:
			path_all.append(paths)
		
	return path_all

func animate_block_on_position(delay_time):	
	for row in MAX_ROW:
		for col in MAX_COL:
			if !block_data[row][col].is_destroy:
				if block_data[row][col].btn_animate.rect_position.x != col * BLOCK_W + (BLOCK_W/2) or block_data[row][col].btn_animate.rect_position.y != row * BLOCK_W + (BLOCK_W/2):										
					block_data[row][col].btn_animate.move_to(col * BLOCK_W , row * BLOCK_W , true, ANIMATE_TIME_BOX_DOWN)					
			else:
				block_data[row][col].btn_animate.queue_free()				
							

# delegate by Cat 
func _on_Cat_run_completed():
	add_delay_wait_to_destroy()
	
func test():
	put_down_block_test()
	
func put_down_block_test():
	print("---- test1 ----")
	var data_test = [
		[{is_destroy=false, value="0"}],
		[{is_destroy=false, value="1"}],
		[{is_destroy=false, value="2"}],
		[{is_destroy=false, value="3"}],
		[{is_destroy=true, value="4"}],
	]
	print("---- ")
	put_down_block(0, data_test)
	print(data_test[0][0].value=="4")
	print(data_test[1][0].value=="0")
	print(data_test[2][0].value=="1")
	print(data_test[3][0].value=="2")
	print(data_test[4][0].value=="3")
	
	print("---- test2 ----")
	data_test = [
		[{is_destroy=false, value="0"}],
		[{is_destroy=false, value="1"}],
		[{is_destroy=true, value="2"}],
		[{is_destroy=false, value="3"}],
		[{is_destroy=true, value="4"}],
	]
	print("---- ")
	put_down_block(0, data_test)
	print(data_test[0][0].value=="2")
	print(data_test[1][0].value=="4")
	print(data_test[2][0].value=="0")
	print(data_test[3][0].value=="1")
	print(data_test[4][0].value=="3")
	
	print("---- test3 ----")
	data_test = [
		[{is_destroy=false, value="0"}],
		[{is_destroy=false, value="1"}],
		[{is_destroy=false, value="2"}],
		[{is_destroy=false, value="3"}],
		[{is_destroy=false, value="4"}],
	]
	print("---- ")
	put_down_block(0, data_test)
	print(data_test[0][0].value=="0")
	print(data_test[1][0].value=="1")
	print(data_test[2][0].value=="2")
	print(data_test[3][0].value=="3")
	print(data_test[4][0].value=="4")
	
	print("---- test4 ----")
	data_test = [
		[{is_destroy=true, value="0"}],
		[{is_destroy=false, value="1"}],
		[{is_destroy=false, value="2"}],
		[{is_destroy=false, value="3"}],
		[{is_destroy=false, value="4"}],
	]
	print("---- ")
	put_down_block(0, data_test)
	print(data_test[0][0].value=="0")
	print(data_test[1][0].value=="1")
	print(data_test[2][0].value=="2")
	print(data_test[3][0].value=="3")
	print(data_test[4][0].value=="4")
	
	print("---- test5 ----")
	data_test = [
		[{is_destroy=true, value="0"}],
		[{is_destroy=false, value="1"}],
		[{is_destroy=false, value="2"}],
		[{is_destroy=false, value="3"}],
		[{is_destroy=false, value="4"}],
	]
	print("---- ")
	put_down_block(0, data_test)
	print(data_test[0][0].value=="0")
	print(data_test[1][0].value=="1")
	print(data_test[2][0].value=="2")
	print(data_test[3][0].value=="3")
	print(data_test[4][0].value=="4")
	



