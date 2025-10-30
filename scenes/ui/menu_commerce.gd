extends Panel

func _ready():
    # Créer un label
    var label = Label.new()
    label.text = "Coucou ! Menu commerce (bientôt plus joli)."
    label.position = Vector2(100, 50)
    add_child(label)

    # Créer un bouton "Retour"
    var bouton = Button.new()
    bouton.text = "Retour au jeu"
    bouton.position = Vector2(100, 100)
    bouton.pressed.connect(_on_bouton_retour_pressed)
    add_child(bouton)

func _on_bouton_retour_pressed():
    get_tree().change_scene_to_file("res://maps/space.tscn")