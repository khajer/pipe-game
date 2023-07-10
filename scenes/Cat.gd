extends AnimatedSprite

const DELAY_TIME_ANIMATE = 1
signal run_completed

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("animation_finished", self, "_on_animation_finished")


func run_to_home():
	print("run to home")
	
	var dif_x = -100	
	$".".play("cat_walk_home")
	var tween = Tween.new()
	add_child(tween)		
	tween.interpolate_property(self, "position", self.position, Vector2(self.position.x+dif_x, self.position.y), DELAY_TIME_ANIMATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)	
	tween.start()
	tween.interpolate_callback(self, DELAY_TIME_ANIMATE/2, "on_run_back_completed")

func on_run_back_completed():
	self.play("eat_fish")#	
	emit_signal("run_completed")
	
func run_to_catch_fish():
	walk()

func walk():
	var dif_x = 20	
	$".".play("walk_pass")
	var tween = Tween.new()
	add_child(tween)		
	tween.interpolate_property(self, "position", self.position, Vector2(self.position.x+dif_x, self.position.y), DELAY_TIME_ANIMATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)	
	tween.start()
	tween.interpolate_callback(self, DELAY_TIME_ANIMATE, "on_walk_completed")


func on_walk_completed():
	run()
	

func run():
	var dif_x = 100	
	$".".play("run")
	var tween = Tween.new()
	add_child(tween)		
	tween.interpolate_property(self, "position", self.position, Vector2(self.position.x+dif_x, self.position.y), DELAY_TIME_ANIMATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)	
	tween.start()
	tween.interpolate_callback(self, DELAY_TIME_ANIMATE, "on_run_completed")
	
func on_run_completed():
	goto_after_run()
	
	
func goto_after_run():
	var dif_x = 30	
	self.play("after_run")
	var tween = Tween.new()
	add_child(tween)		
	tween.interpolate_property(self, "position", self.position, Vector2(self.position.x+dif_x, self.position.y), DELAY_TIME_ANIMATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)	
	tween.start()
	tween.interpolate_callback(self, DELAY_TIME_ANIMATE, "on_after_run_completed")
	
func on_after_run_completed():
	catch_fish()

func catch_fish():
	self.play("catch_fish")#	
	
func on_catch_fish_completed():
	print("pass")

func _on_animation_finished():
	if($".".animation == "catch_fish"):
		wating_to_go_back()


func wating_to_go_back():
	self.play("waiting_to_go_back")#	
	emit_signal("run_completed")
	
