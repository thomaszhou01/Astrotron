extends CanvasLayer

var healthPack = preload("res://Scenes/Items/healthPack.tscn")
var shieldCell = preload("res://Scenes/Items/shieldCell.tscn")
var ammo = preload("res://Scenes/Items/Ammo.tscn")
var railGun = preload("res://Scenes/Weapons/RailGun.tscn")
var pulseCannon = preload("res://Scenes/Weapons/PulseCannon.tscn")
var grenadeLauncher = preload("res://Scenes/Weapons/GrenadeLauncher.tscn")
var rocketLauncher = preload("res://Scenes/Weapons/RocketLauncher.tscn")
var miniGun = preload("res://Scenes/Weapons/MiniGun.tscn")
var gunType
var gunNumb
var gunCost
var sellsShields
var inWindow
var totalCost = 0
var bought 

var boughtGun = false
var boughtHealth = false
var boughtShield = false
var boughtAmmo = false
var ammoBought = 0
var purchaseAmmo = 0
var initialAmmo

# Called when the node enters the scene tree for the first time.
func _ready():
	gunNumb = get_parent().gunNumb
	sellsShields = get_parent().sellsShields
	initialAmmo = 5
	if sellsShields:
		$Window/ShieldImage.visible = true
		$Window/ShieldButton.visible = true
		$Window/ShieldText.visible = true
		$Window/ShieldQuantity.visible = true
	else:
		$Window/ShieldImage.visible = false
		$Window/ShieldButton.visible = false
		$Window/ShieldText.visible = false
		$Window/ShieldQuantity.visible = false
	
	$Window/GunImage.region_rect = Rect2(gunNumb * 16, 0, 16, 16)
	
	if gunNumb == 0:
		gunType = railGun
		gunCost = 30
		$Window/GunText.text = "RailGun: \n-Damage 50\n-Fast Firerate\n-10 round clip\n\n\n30 gold"
	elif gunNumb == 1:
		gunType = pulseCannon
		gunCost = 40
		$Window/GunText.text = "PulseCannon: \n-Damage 100\n-Medium Firerate\n-5 round clip\n\n\n40 gold"
	elif gunNumb == 5:
		gunType = grenadeLauncher
		gunCost = 50
		$Window/GunText.text = "GrenadeLauncher: \n-Damage 150\n-Medium Firerate\n-4 round clip\n\n\n50 gold"
	elif gunNumb == 4:
		gunType = miniGun
		gunCost = 60
		$Window/GunText.text = "MiniGun: \n-Damage 20\n-VeryFast Firerate\n-50 round clip\n\n\n60 gold"
	elif gunNumb == 3:
		gunType = rocketLauncher
		gunCost = 70
		$Window/GunText.text = "RocketLauncher: \n-Damage 300\n-Slow Firerate\n-3 round clip\n\n\n70 gold"
	

func _process(delta):
	$Window/moneyText.text = String(Global.money - totalCost)

func _input(event):
	inWindow = get_parent().inWindow
	if !inWindow && !bought:
		totalCost = 0
		bought = false
		if boughtShield:
			boughtShield = false
			$Window/ShieldButton.disabled = false
			$Window/ShieldQuantity.text = ("Quantity: 1")
		if boughtGun:
			boughtGun = false
			$Window/GunButton.disabled = false
			$Window/GunQuantity.text = ("Quantity: 1")
		if boughtHealth: 
			boughtHealth = false
			$Window/HealthButton.disabled = false
			$Window/HealthQuantity.text = ("Quantity: 1")
		if boughtAmmo:
			boughtAmmo = false
			ammoBought = 5-initialAmmo
			purchaseAmmo = 0
			$Window/AmmoButton.disabled = false
			$Window/AmmoQuantity.text = ("Quantity: %s") % (initialAmmo)
	else:
		bought = false
	

func _on_ShieldButton_pressed():
	boughtShield = true
	$Window/ShieldButton.disabled = true
	$Window/ShieldQuantity.text = ("Quantity: 0")
	totalCost += 10


func _on_GunButton_pressed():
	boughtGun = true
	$Window/GunButton.disabled = true
	$Window/GunQuantity.text = ("Quantity: 0")
	totalCost += gunCost


func _on_AmmoButton_pressed():
	boughtAmmo = true
	if ammoBought <5:
		ammoBought += 1
		purchaseAmmo += 1
		$Window/AmmoQuantity.text = ("Quantity: %s") % (5-ammoBought)
		totalCost += 5
	else:
		$Window/AmmoButton.disabled = true


func _on_HealthButton_pressed():

	boughtHealth = true
	$Window/HealthButton.disabled = true
	$Window/HealthQuantity.text = ("Quantity: 0")
	totalCost += 10


func _on_BuyButton_pressed():
	if totalCost <= Global.money:
		bought = true
		Global.money -= totalCost
		totalCost = 0
		if boughtHealth:
			var health_instance = healthPack.instance()
			get_parent().get_parent().get_parent().call_deferred("add_child", health_instance)
			health_instance.position = get_parent().get_parent().position
			boughtHealth = false
		if boughtGun:
			var gun_Instance = gunType.instance()
			get_parent().get_parent().get_parent().get_parent().call_deferred("add_child", gun_Instance)
			gun_Instance.position = get_parent().get_parent().position
			boughtGun = false
		if boughtShield:
			var shield_instance = shieldCell.instance()
			get_parent().get_parent().get_parent().call_deferred("add_child", shield_instance)
			shield_instance.position = get_parent().get_parent().position
			boughtShield = false
		if boughtAmmo:
			initialAmmo -= purchaseAmmo
			for i in range(0, purchaseAmmo):
				var ammo_instance = ammo.instance()
				get_parent().get_parent().get_parent().call_deferred("add_child", ammo_instance)
				ammo_instance.position = get_parent().get_parent().position
			boughtAmmo = false
			purchaseAmmo = 0
