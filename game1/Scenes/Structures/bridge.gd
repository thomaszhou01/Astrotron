extends Node2D

const PIN_SEPERATION = 14
export (int) var pieces
var currentBridge
var bridgePiece = preload("res://Scenes/Structures/bridgePiece.tscn")


func _ready():
	
	#already spawns the pins and bridge pieces
	#implement attachment process
	var pinNode = PinJoint2D.new()
	add_child(pinNode)
	for i in range(0, pieces):
		currentBridge = bridgePiece.instance()
		self.add_child(currentBridge)
		addPiece()
		print(i)


func addPiece():
	print("adding")
