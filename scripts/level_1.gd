extends Node2D

@onready var level_1: Node2D = $"."
@onready var barrier_block: Node2D = $barrier_block
@onready var upper_barrier: Sprite2D = $barrier_block/upper_barrier
@onready var botterm_barrier: Sprite2D = $barrier_block/botterm_barrier

@export var speed: float
@export var gap: Vector2
@export var player_stats: PlayerStat
var barrier_amount: Array[Node2D]
var start: bool = false
var score: int 

signal game_over(socre: int)

func _ready() -> void:
	barrier_amount.append(barrier_block)
	randomize()

func _process(delta: float) -> void:
	if (start):
		move_barrier(delta)
	
	place_new_barrier()
	
	clean_up_blocks()


func move_barrier(delta: float) -> void:
	for block in barrier_amount:
		block.position. x -= speed * delta
		
func place_new_barrier() -> void:
	if check_barrier_amount() < 2:
		var f1: Node2D = get_first_barrier(barrier_amount)
		if f1 == null:
			return
		else:
			# place new block from x: 512 away from last block
				# create new block 
				# change the position
				# randomize y cordinates and gap
				# add new block to array
				# add new block to the tree ---------------------- clearn_up_blocks()
				# remove epired blocks from array and the tree --- clean_up_blocks()
			var new_block: Node2D = f1.duplicate()
			new_block.position.x += 512
			new_block.get_child(0).position.y = barrier_block.get_child(0).position.y - randf_range(gap.x, gap.y)
			new_block.get_child(1).position.y = barrier_block.get_child(1).position.y + randf_range(gap.x, gap.y)
			if (randi() % 100)%2 == 0:
				new_block.position.y = barrier_block.position.y + randf_range(gap.x, gap.y)
			else:
				new_block.position.y = barrier_block.position.y - randf_range(gap.x, gap.y)
			barrier_amount.append(new_block)
			level_1.add_child(new_block)
			

# this function clean up the barrier blocks if it does not appear on the screen
func clean_up_blocks():
	var f1: Node2D = get_first_barrier(barrier_amount)
	if f1 == null:
		var block: Node2D = barrier_amount.pop_front()
		level_1.remove_child(block)
		

# this function return the first barrier only if it does appear on the screen
func get_first_barrier(arg: Array[Node2D]) -> Node2D:
	if arg[0].position.x + 64 < 0:
		return null
	else: 
		return arg[0]

# return the length of barrier_amount array
func check_barrier_amount() -> int:
	return len(barrier_amount)


func _on_main_menu_start() -> void:
	start = true


func _on_main_menu_stop() -> void:
	start = false


# bird collide with barriers -------------> 
func _on_upper_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Bird":
		emit_signal("game_over", score)

func _on_bottem_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Bird":
		emit_signal("game_over", score)
# bird collide with barriers -------------> 
