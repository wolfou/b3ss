extends GutTest
var player_scene = preload("res://scenes/player/player.tscn")
var meteor_scene = preload("res://scenes/environment/meteor.tscn")
var player
var meteor
var hud
var prompt
var interaction_manager
var sender
var pilot_controls
var pilot_controls_double

func before_each():
	player = player_scene.instantiate()
	add_child_autofree(player)
	meteor = meteor_scene.instantiate()
	add_child_autofree(meteor)
	meteor.add_to_group("interactables")
	hud = player.hud
	prompt = hud.get_node("InteractionPrompt")
	interaction_manager = player.interaction_manager

func test_interaction_far():
	meteor.global_position = player.global_position + Vector3(100, 0, 0)
	await wait_physics_frames(2)
	assert_false(prompt.visible, "Le prompt ne devrait pas être visible quand loin.")
	assert_null(interaction_manager.current_interactable, "can_interact doit rester false")

func test_interaction_near():
	meteor.global_position = player.global_position + Vector3(2, 0, 0)
	await wait_physics_frames(2)
	assert_true(prompt.visible, "Le prompt devrait être visible quand proche.")
	assert_eq(prompt.text, "Appuyez sur F pour miner", "Texte incorrect.")
	assert_eq(interaction_manager.current_interactable, meteor, "current_interactable doit être le météorite.")

func test_interaction_in_out():
	meteor.global_position = player.global_position + Vector3(2, 0, 0)
	await wait_physics_frames(2)
	assert_true(prompt.visible, "Prompt visible quand proche.")
	assert_eq(interaction_manager.current_interactable, meteor, "current_interactable doit être le météorite.")

	meteor.global_position = player.global_position + Vector3(100, 0, 0)
	await wait_physics_frames(2)
	assert_false(prompt.visible, "Prompt caché quand loin.")
	assert_null(interaction_manager.current_interactable, "can_interact doit passer à false quand l'objet est loin")
	
func test_interact_in_range():
	meteor.global_position = player.global_position + Vector3(2, 0, 0)
	await wait_physics_frames(2)

	assert_eq(interaction_manager.current_interactable, meteor)

	await wait_physics_frames(2)
	Input.action_press("interact")
	await wait_physics_frames(1)

	assert_null(meteor, "Le météorite doit être détruit.")

func test_interact_out_of_range():
	meteor.global_position = player.global_position + Vector3(100, 0, 0)
	await wait_physics_frames(2)

	assert_null(interaction_manager.current_interactable)

	await wait_physics_frames(2)
	Input.action_press("interact")
	await wait_physics_frames(1)

	assert_not_null(meteor, "Le météorite doit être détruit.")
