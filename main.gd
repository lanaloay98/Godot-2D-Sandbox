extends Node2D

@export var brushSize:=1
const Bedrock={"source":0,"atlas":Vector2i(13,21)}
const Sand={"source":1,"atlas":Vector2i(35,21)}
const Water={"source":2,"atlas":Vector2i(61,24)}
var current=Bedrock
@onready var tileset = $World

func _ready() -> void:
	pass

func checkIfCellIsEmpty(pos:Vector2i)->bool:
	return tileset.get_cell_source_id(0, pos) == -1

func setTile(pos: Vector2i, tile_data: Dictionary):
	tileset.set_cell(0,pos,tile_data["source"],tile_data["atlas"])

func clearTile(pos: Vector2i):
	tileset.set_cell(0,pos,-1)

func getCellSource(pos:Vector2i)->int:
	return tileset.get_cell_source_id(0,pos)

func getCellAtlas(pos: Vector2i)->Vector2i:
	return tileset.get_cell_atlas_coords(0,pos)

func loopTileSet():
	var cells = tileset.get_used_cells(0)
	cells.shuffle()

	for cell in cells:
		if getCellSource(cell)==Sand["source"] and getCellAtlas(cell)==Sand["atlas"]:
			var below=cell+Vector2i(0,1)
			var down_left=cell+Vector2i(-1,1)
			var down_right=cell+Vector2i(1,1)
			if getCellSource(below)==Water["source"] and getCellAtlas(below)==Water["atlas"]:
				setTile(cell,Water)
				setTile(below,Sand)
			elif checkIfCellIsEmpty(below):
				clearTile(cell)
				setTile(below,Sand)
			elif checkIfCellIsEmpty(down_left):
				clearTile(cell)
				setTile(down_left,Sand)
			elif checkIfCellIsEmpty(down_right):
				clearTile(cell)
				setTile(down_right,Sand)

		elif getCellSource(cell)==Water["source"] and getCellAtlas(cell)==Water["atlas"]:
			var below=cell+Vector2i(0,1)
			var left=cell+Vector2i(-1,0)
			var right=cell+Vector2i(1,0)
			if checkIfCellIsEmpty(below):
				clearTile(cell)
				setTile(below,Water)
			elif checkIfCellIsEmpty(left):
				clearTile(cell)
				setTile(left,Water)
			elif checkIfCellIsEmpty(right):
				clearTile(cell)
				setTile(right,Water)

func _process(delta:float)->void:
	loopTileSet()

	if Input.is_action_just_pressed("1"):
		current=Bedrock
	elif Input.is_action_just_pressed("2"):
		current=Sand
	elif Input.is_action_just_pressed("3"):
		current=Water

	if Input.is_action_pressed("leftclick"):
		var base=tileset.local_to_map(get_global_mouse_position())
		for x in range(-brushSize,brushSize+1):
			for y in range(-brushSize,brushSize+1):
				setTile(base+Vector2i(x,y),current)

	if Input.is_action_pressed("rightclick"):
		var base=tileset.local_to_map(get_global_mouse_position())
		for x in range(-brushSize,brushSize+1):
			for y in range(-brushSize,brushSize+1):
				clearTile(base+Vector2i(x,y))
