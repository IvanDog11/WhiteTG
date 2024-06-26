/obj/structure/closet/secure_closet/freezer
	icon_state = "freezer"
	base_icon_state = "freezer"
	flags_1 = PREVENT_CONTENTS_EXPLOSION_1
	door_anim_squish = 0.22
	door_anim_angle = 123
	door_anim_time = 4
	/// If FALSE, we will protect the first person in the freezer from an explosion / nuclear blast.
	var/jones = FALSE
	paint_jobs = null

/obj/structure/closet/secure_closet/freezer/before_open(mob/living/user, force)
	. = ..()
	if(!.)
		return FALSE

	toggle_organ_decay(src)
	return TRUE

/obj/structure/closet/secure_closet/freezer/after_close(mob/living/user)
	. = ..()
	toggle_organ_decay(src)

/obj/structure/closet/secure_closet/freezer/Destroy()
	toggle_organ_decay(src)
	return ..()

/obj/structure/closet/secure_closet/freezer/Initialize(mapload)
	. = ..()
	toggle_organ_decay(src)

/obj/structure/closet/secure_closet/freezer/ex_act()
	if(jones)
		return ..()
	jones = TRUE
	flags_1 &= ~PREVENT_CONTENTS_EXPLOSION_1
	return FALSE

/obj/structure/closet/secure_closet/freezer/deconstruct(disassembled)
	if (!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/assembly/igniter/condenser(drop_location())
	. = ..()

/obj/structure/closet/secure_closet/freezer/empty
	name = "холодильник"

/obj/structure/closet/secure_closet/freezer/empty/open
	req_access = null
	locked = FALSE

/obj/structure/closet/secure_closet/freezer/kitchen
	name = "кухонный шкаф"
	req_access = list(ACCESS_KITCHEN)

/obj/structure/closet/secure_closet/freezer/kitchen/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/condiment/flour(src)
	new /obj/item/reagent_containers/condiment/rice(src)
	new /obj/item/reagent_containers/condiment/sugar(src)

/obj/structure/closet/secure_closet/freezer/kitchen/all_access
	req_access = null

/obj/structure/closet/secure_closet/freezer/kitchen/maintenance
	name = "подпольный холодильник"
	desc = "Этот холодильник выглядит довольно пыльным, есть ли внутри что-нибудь съедобное?"
	req_access = null

/obj/structure/closet/secure_closet/freezer/kitchen/maintenance/PopulateContents()
	..()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/condiment/milk(src)
		new /obj/item/reagent_containers/condiment/soymilk(src)
	for(var/i in 1 to 2)
		new /obj/item/storage/fancy/egg_box(src)

/obj/structure/closet/secure_closet/freezer/kitchen/mining
	req_access = null

/obj/structure/closet/secure_closet/freezer/meat
	name = "мясной холодильник"
	req_access = list(ACCESS_KITCHEN)

/obj/structure/closet/secure_closet/freezer/meat/PopulateContents()
	..()
	for(var/i in 1 to 4)
		new /obj/item/food/meat/slab/monkey(src)

/obj/structure/closet/secure_closet/freezer/meat/open
	locked = FALSE
	req_access = null

/obj/structure/closet/secure_closet/freezer/meat/all_access
	req_access = null

/obj/structure/closet/secure_closet/freezer/gulag_fridge
	name = "холодильник"

/obj/structure/closet/secure_closet/freezer/gulag_fridge/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/cup/glass/bottle/beer/light(src)

/obj/structure/closet/secure_closet/freezer/fridge
	name = "холодильник"
	req_access = list(ACCESS_KITCHEN)

/obj/structure/closet/secure_closet/freezer/fridge/PopulateContents()
	..()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/condiment/milk(src)
		new /obj/item/reagent_containers/condiment/soymilk(src)
	for(var/i in 1 to 2)
		new /obj/item/storage/fancy/egg_box(src)

/obj/structure/closet/secure_closet/freezer/fridge/all_access
	req_access = null

/obj/structure/closet/secure_closet/freezer/fridge/open
	req_access = null
	locked = FALSE

/obj/structure/closet/secure_closet/freezer/fridge/preopen
	req_access = null
	locked = FALSE
	opened = TRUE

/obj/structure/closet/secure_closet/freezer/money
	name = "морозильная камера"
	desc = "Холодная наличность."
	req_access = list(ACCESS_VAULT)

/obj/structure/closet/secure_closet/freezer/money/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/stack/spacecash/c1000(src)
	for(var/i in 1 to 5)
		new /obj/item/stack/spacecash/c500(src)
	for(var/i in 1 to 6)
		new /obj/item/stack/spacecash/c200(src)

/obj/structure/closet/secure_closet/freezer/cream_pie
	name = "морозилка с пирогами"
	desc = "Содержит пироги со сливками и/или заварным кремом, болваны."
	req_access = list(ACCESS_THEATRE)

/obj/structure/closet/secure_closet/freezer/cream_pie/PopulateContents()
	..()
	new /obj/item/food/pie/cream(src)
