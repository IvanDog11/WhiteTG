/datum/crafting_recipe/shutters
	name = "Бронежалюзи"
	reqs = list(
		/obj/item/stack/sheet/plasteel = 5,
		/obj/item/stack/cable_coil = 5,
		/obj/item/electronics/airlock = 1,
	)
	result = /obj/machinery/door/poddoor/shutters/preopen
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 10 SECONDS
	category = CAT_DOORS
	one_per_turf = TRUE

/datum/crafting_recipe/blast_doors
	name = "Бронеставни"
	reqs = list(
		/obj/item/stack/sheet/plasteel = 15,
		/obj/item/stack/cable_coil = 15,
		/obj/item/electronics/airlock = 1,
	)
	result = /obj/machinery/door/poddoor/preopen
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 30 SECONDS
	category = CAT_DOORS
	one_per_turf = TRUE
