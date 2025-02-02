extends Control

var firstParts: Array[String] = [
	"Crys", "Dan", "Gon", "Laz", "Mas", "Mash", "Phoe", 
	"Sha", "Si", "Sky", "Star", "Tony", "Watch", "Wi"
]
var lastParts: Array[String] = [
	"cap", "don", "el", "er", "fla", 
	"gon", "knight", "lez", "light", "pho",  
	"sha", "slo", "tal", "tic"
]

@export var levelScene: Node3D

var playerKart: Kart = null

var aiKarts: Dictionary = {}
var allLabels: Array[Label] = []

@export var labelTheme: Theme

var labelNameMaxWidth: int = 150
var labelMaxWidth: int = 250
var ySpacing: int = 20

func getLabelNameText(entityName: String) -> String:
	var font: Font = labelTheme.get_font("font", "Label")
	var trimmedName: String = entityName
	
	if font.get_string_size(entityName).x > labelNameMaxWidth:
		var i: int = 0
		while font.get_string_size(trimmedName + "...").x > labelNameMaxWidth and i < 10:
			trimmedName = trimmedName.substr(0, trimmedName.length()-2)
			i += 1
		trimmedName += "..."
	
	return trimmedName

func createDefaultLabel(entityName: String, yLevel: int = 0):
	var label = Label.new()
	label.position = Vector2(get_viewport_rect().size.x - labelMaxWidth - 10, yLevel * ySpacing)
	label.size.x = labelMaxWidth
	label.theme = labelTheme
	label.text = entityName
	add_child(label)
	return label
	
func PRINT(arr: Array):
	for i in range(len(arr)/2):
		print("%s, " % arr[i*2+1].text)
	print("\n")

func _ready() -> void:
	playerKart = levelScene.playerKart
	var allKartsAI: Array = get_tree().get_nodes_in_group("ai_kart")
	
	# Meant to be set in editor   vvvv =Falback
	if not labelTheme:
		labelTheme = Theme.new()
	
	var playerLabelScore = Label.new()
	playerLabelScore.position = Vector2(get_viewport_rect().size.x - labelMaxWidth - 10, 0)
	playerLabelScore.size.x = labelMaxWidth
	playerLabelScore.theme = labelTheme
	playerLabelScore.text = "0"
	playerLabelScore.add_theme_color_override("font_color", Color(0.5, 0, 0.5))
	playerLabelScore.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(playerLabelScore)
	allLabels.push_back(playerLabelScore)
	
	var playerLabelName: Label = Label.new()
	playerLabelName.theme = labelTheme
	playerLabelName.text = "You"
	playerLabelName.add_theme_color_override("font_color", Color(0.5, 0, 0.5))
	playerLabelScore.add_child(playerLabelName)
	
	for i: int in range(len(allKartsAI)):
		var currentName: String = firstParts.pick_random() + lastParts.pick_random()
		
		var aiLabelScore = Label.new()
		aiLabelScore.position = Vector2(get_viewport_rect().size.x - labelMaxWidth - 10, (i+1) * ySpacing)
		aiLabelScore.size.x = labelMaxWidth
		aiLabelScore.theme = labelTheme
		aiLabelScore.text = "0"
		aiLabelScore.add_theme_color_override("font_color", Color(0, 0.5, 0.5))
		aiLabelScore.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		add_child(aiLabelScore)
		allLabels.push_back(aiLabelScore)
		
		var aiLabelName: Label = Label.new()
		aiLabelName.theme = labelTheme
		aiLabelName.text = currentName
		aiLabelName.add_theme_color_override("font_color", Color(0, 0.5, 0.5))
		aiLabelScore.add_child(aiLabelName)
		
		aiKarts[currentName] = allKartsAI[i]


func sortNames(labelA: Label, labelB: Label) -> bool:
	#for i: int in range(len(allLabels) / 2):
		#var j: int = (i + 1) % (len(allLabels) / 2)
		#var targetPrecedance: bool = int(allLabels[2*i+1].text) > int(allLabels[2*j+1].text)
		#var actualPrecedance: bool = allLabels[2*i+1].position.y < allLabels[2*j+1].position.y
		#
		#if actualPrecedance != targetPrecedance:
			#var yLevelI: int = allLabels[2*i].position.y
			#var yLevelJ: int = allLabels[2*j].position.y
			#allLabels[2*i].position.y = yLevelJ
			#allLabels[2*i+1].position.y = yLevelJ
			#allLabels[2*j].position.y = yLevelI
			#allLabels[2*j+1].position.y = yLevelI
	

	var targetPrecedance: bool = int(labelA.text) > int(labelB.text)
	var actualPrecedance: bool = labelA.position.y < labelB.position.y
	
	if actualPrecedance != targetPrecedance:
		var yLevelA: int = labelA.position.y
		var yLevelB: int = labelB.position.y
		labelA.position.y = yLevelB
		labelA.position.y = yLevelB
		labelB.position.y = yLevelA
		labelB.position.y = yLevelA
		return true
	
	return false


func _process(delta: float) -> void:
	var playerDiscovered: bool = false
	var ogLength: int = len(allLabels)
	for j: int in range(ogLength):
		var i: int = ogLength - 1 - j
		var kartName: String = allLabels[i].get_child(0).text
		if kartName == "You":
			playerDiscovered = true
			allLabels[i].text = str(int(levelScene.distanceTraveled))
			continue
		elif not is_instance_valid(aiKarts[kartName]):
			allLabels[i].queue_free()
			allLabels.remove_at(i)
			aiKarts[kartName] = null
			print("ARGHHH")
			continue
		allLabels[i].text = str(int(aiKarts[kartName].distanceTraveled))
	allLabels.sort_custom(sortNames)
	
