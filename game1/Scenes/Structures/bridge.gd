extends Node2D

const PIN_SEPERATION = 16
const SOFTNESS = 0.003
export (int) var pieces
var currentBridge
var pinNode
var bridgePiece = preload("res://Scenes/Structures/bridgePiece.tscn")
var pieceLeft
var pieceRight
var spawnPinLocX = PIN_SEPERATION/2
var spawnBridgeLocX = 0
var bridgePoints = {}

func _ready():
	pieceLeft = NodePath($bridgePiece.get_path())
	
	#already spawns the pins and bridge pieces
	#implement attachment process
	for i in range(0, pieces):
		currentBridge = bridgePiece.instance()
		spawnBridgeLocX += PIN_SEPERATION
		currentBridge.position = Vector2(spawnBridgeLocX, 0)
		add_child(currentBridge)
		pieceRight = NodePath(currentBridge.get_path())
		
		
		pinNode = PinJoint2D.new()
		pinNode.position = Vector2(spawnPinLocX, 6.5)
		spawnPinLocX += PIN_SEPERATION
		pinNode.softness = SOFTNESS
		pinNode.node_a = pieceLeft
		pinNode.node_b = pieceRight
		add_child(pinNode)
		bridgePoints[currentBridge] = pinNode
		pieceLeft = NodePath(currentBridge.get_path())
	currentBridge.set_mode(1)

func detach(node):
	if bridgePoints.get(node) != null:
		bridgePoints[node].queue_free()
	if node.mode == 1:
		node.call_deferred("set_mode", 0)
