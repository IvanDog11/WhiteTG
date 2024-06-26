/datum/lazy_template/virtual_domain/legion
	name = "Палата Эха"
	cost = BITRUNNER_COST_MEDIUM
	desc = "Леденящее душу царство, в котором находится некрополь Легиона. Те, кто сдался ему, навеки прокляты."
	difficulty = BITRUNNER_DIFFICULTY_MEDIUM
	forced_outfit = /datum/outfit/job/miner
	key = "legion"
	map_name = "legion"
	reward_points = BITRUNNER_REWARD_MEDIUM
	safehouse_path = /datum/map_template/safehouse/lavaland_boss

/mob/living/simple_animal/hostile/megafauna/legion/virtual_domain
	can_be_cybercop = FALSE
	crusher_loot = list(/obj/structure/closet/crate/secure/bitrunning/encrypted)
	health = 1500
	loot = list(/obj/structure/closet/crate/secure/bitrunning/encrypted)
	maxHealth = 1500
	true_spawn = FALSE

// You may be thinking, what about those mini-legions? They're not part of the initial created_atoms list
